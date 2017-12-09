from sklearn.linear_model import LogisticRegression

from credentials import HOST, USERNAME, PASSWORD, DBNAME

from sqlalchemy import create_engine, Table, MetaData, Column, Integer, String, Date, Boolean, Float
from sqlalchemy.sql import select
import numpy as np

if __name__=="__main__":

    conn_str = "mysql+pymysql://{0}:{1}@{2}/{3}".format(USERNAME, PASSWORD , HOST, DBNAME)

    engine = create_engine(conn_str)
    metadata = MetaData()
    conn = engine.connect()
    dataset = Table('dataset', metadata,
                  Column('hash_number_A', Integer),
                  Column('dd', Date),
                  Column('horyzon', Integer),
                  Column('target', Boolean),
                  Column('recency_factor', Integer),
                  Column('frequency_factor', Float),
                  Column('monetary_factor', Float))

    s = select([dataset])
    result = conn.execute(s)

    # X = np.empty((0, 100))
    # y = np.empty((0, 100))
    X = list()
    y = list()
    for row in result:
        hash_number_A, dd, horyzon, target, recency_factor, frequency_factor, monetary_factor = row
        X.append((horyzon, target, recency_factor, frequency_factor, monetary_factor))
        y.append(target)

    lgr = LogisticRegression()
    lgr.fit(X=X, y=y)
