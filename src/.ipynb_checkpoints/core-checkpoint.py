import re
import pandas as pd
import pathlib as pl

def rpt_to_pd(rpt:pl.Path):
    """
    Description:
      Parses the output of Bulletin 17C peakFQ analysis into a pandas datafram
    Input:
      rpt: a link to the output of a peakFQ analysis
    Returns:
      A dataframe with the results of the peakFQ analysis/
    """
    feq_pattern = '(?<=<< Frequency Curve >>\n)[\s\S]+?(?=\n\n\n<<)'
    with open(str(rpt),'r') as c:
        content = c.read()
    freq = re.search(feq_pattern,content)
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
    df_dict = {}
    data_list = re.findall('[\w,]+[\s.(]{0,1}\w+\){0,1}',data_raw)
    assert len(data_list)%len(cols_dict) == 0, "columns and data don't align"
    for key, val in cols_dict.items():
        for j, fl in enumerate(data_list):
            if j%len(cols_dict) == key:
                #print(val,fl)
                df_dict.setdefault(val,[]).append(fl)
    df = pd.DataFrame.from_dict(df_dict)
    return df