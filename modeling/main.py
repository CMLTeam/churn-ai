from sklearn.linear_model import LogisticRegression
from sklearn.cross_validation import cross_val_score

from credentials import HOST, USERNAME, PASSWORD, DBNAME

from sqlalchemy import create_engine, Table, MetaData, Column, Integer, String, Date, Boolean, Float
from sqlalchemy.sql import select
import numpy as np

if __name__=="__main__":

    conn_str = 'mysql+pymysql://{0}:{1}@{2}/{3}'.format(USERNAME, PASSWORD , HOST, DBNAME)

    engine = create_engine(conn_str)
    metadata = MetaData()
    conn = engine.connect()

    dataset = Table('dataset_cut', metadata,
                  Column('hash_number_A', Integer),
                  Column('dd', Date),
                  Column('horyzon', Integer),
                  Column('t', Integer),
                  Column('recency', Integer),
                  Column('frequency', Float),
                  Column('monetary', Float))

    s = select([dataset])
    result = conn.execute(s)

    X = list()
    y = list()

    rows = 0
    for row in result:
        hash_number_A, dd, horyzon, t, recency, frequency, monetary = row
        X.append((horyzon, recency, frequency, monetary))
        y.append(t)
        rows = rows + 1

    lgr = LogisticRegression()
    lgr.fit(X=X, y=y)
    crossval_scores = cross_val_score(lgr, X, y, scoring='roc_auc')
    # 85%
    print('ROC-AUC test run scores: ', crossval_scores)
    print(rows)