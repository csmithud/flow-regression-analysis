import re
import pandas as pd
import pathlib as pl
import glob

def rpt_to_parquet(rpt_list:str,gage_id:str,out_folder:pl.Path):
    """
    Description:
      Parses the output of Bulletin 17C peakFQ analysis into a pandas datafram
    Input:
      rpt: a link to the output of a peakFQ analysis
    Output:
      A parquet dataframe with the results of the peakFQ analysis
    Returns: None
    """
    #handle empty or multiple report instances
    if not rpt_list:
        return None
    rpts = rpt_list.split('; ')
    if not rpts:
        return None
    compare_in_effect = False
    df_dict_out ={}
    for rpt in rpts:
        df_dict = {}
        feq_pattern = '(?<=<< Frequency Curve >>\n)[\s\S]+?(?=\n\n\n<<)'
        with open(str(rpt),'r') as c:
            content = c.read()
        ##replace missing data with -9999
        content = content.replace(' --- ','-9999 ')
        freq = re.search(feq_pattern,content)
        if not freq:
            print(f"No frequency data pattern found in {rpt} .skipping")
            continue
            
        freq_text=freq.group()

        m = re.finditer('[-\|]{2,}',freq_text)
        idx = []
        for match in m:
            idx.append(match.span())

        name_raw = freq_text[:idx[0][0]]
        headers_raw = freq_text[idx[0][1]:idx[1][0]]
        data_raw = freq_text[idx[1][1]:idx[2][0]]


        #data name
        name = re.search('[^\\n]+',name_raw).group()
        #column headers
        h = re.finditer('[^\\n]+',headers_raw)
        line = 0
        cols_dict = {}
        for h_match in h:
            l = h_match.group()
            header_cols = re.findall('[\w,]+[\s.(]{0,1}\w+\){0,1}',l)
            if line == 0:
                #get header col length
                for i, col_text in enumerate(header_cols):
                    cols_dict[i] = header_cols[i]
            else:
                if len(header_cols) >len(cols_dict):
                    #extend dictionary out for repeat headers
                    cols_dict[len(cols_dict)] = cols_dict[len(cols_dict)-1]
                if len(header_cols) < len(cols_dict):
                    #extend data based on report format
                    header_cols.insert(1,'')
                    header_cols.insert(3,header_cols[0])
                for i, col_text in enumerate(header_cols):
                    cols_dict[i]+= ' ' + col_text
            line+=1
        #data
        
        data_list = re.findall('[-\w,]+[\s.(]{0,1}\w+\){0,1}',data_raw)
        assert len(data_list)%len(cols_dict) == 0, f"columns and data don't align for {rpt}"
        for key, val in cols_dict.items():
            for j, fl in enumerate(data_list):
                if j%len(cols_dict) == key:
                    #print(val,fl)
                    df_dict.setdefault(val,[]).append(fl)
        #assert that mutiple report is duplicative
        if df_dict and df_dict_out:
            compare_in_effect = True
        if not compare_in_effect:
            df = pd.DataFrame.from_dict(df_dict)
            df_dict_out = df_dict
        else:
            df2 = pd.DataFrame.from_dict(df_dict)
            if not df.equals(df2):
                print (f"There are different results results for the same gage at {rpts}")
                return None
    assert df_dict_out, "No frequency data is being assigned. Debug."
    p_name = f'{gage_id}.parquet'
    df.to_parquet(out_folder/p_name)
    return None

def find_rpt_link(x:str,rpts_folder:pl.Path):
    """
    Description:
      searches through a list of links to find links with a certain ID in the name
    Input:
      x: gage id or other pattern
      rpts: links a folder with peakFQ analyses
    Returns: a string with a list of links that qualify separated by a "; "
    """
    out = ""
    rpts = glob.glob(str(rpts_folder)+'/**/*.rpt', recursive=True)
    for lnk in rpts:
        if lnk.find(str(x)) >= 0:
            if out != '':
                out+='; '
            out+=lnk
    if len(out) == 0:
        for lnk in rpts:
            with open(str(lnk),'r') as c:
                content = c.read()
                if content.find(str(x))>= 0:
                    if out != '':
                        out+='; '
                    out+=lnk
        if len(out) == 0:
            return None
        else:
            return out
    else:
        return out
    
def concat_gage_tables(gage_table:pd.DataFrame,parquet_links:list,transfer_variables:list):
    """
    Description:
      reads in a list of links to standardized peakFQ output files and concats them to a list after adding relevant variables from a gage summary table.
    Input:
      gage_table: gage summary table with gage id and other explanatory variables (e.g., draininage area)
      parquet_links: a list of paths to the standardized peakFQ output created by the rpt_to_parquet function.
      transfer_variables: a list of variables that need to be included from the gage_table variable.
    Returns: a dataframe with flow data for each recurrence interval
    """
    dfs = []
    for p in parquet_links:
        df = pd.read_parquet(p)
        gage_id = int(p.split('\\')[-1].split('.')[0])
        df['GID'] = gage_id
        for col in df.columns:
            if df[col].dtype == 'O':
                df[col] = pd.to_numeric(df[col].str.replace(',', ''), errors='coerce')
        #print(gage_id)
        for v in transfer_variables:
            df[v] = gage_table.loc[gage_table['GID'] == gage_id,v].iloc[0]
            #print(gage_table.loc[gage_table['GID'] == gage_id,v])
        #print(df)
        dfs.append(df)
    return pd.concat(dfs)