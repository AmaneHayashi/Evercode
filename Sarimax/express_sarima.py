#!/usr/bin/env python
# coding: utf-8

# In[1]:


# !/usr/bin/env python

# author: Amane Hayashi

# 导入库
import pandas as pd
from IPython import get_ipython

pd.set_option('max_rows', 150)
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

get_ipython().magic(u'matplotlib inline')
import warnings

warnings.filterwarnings('ignore')

from statsmodels.graphics.tsaplots import plot_acf, plot_pacf
from statsmodels.tsa.seasonal import seasonal_decompose
from statsmodels.tsa.stattools import adfuller

from scipy.stats import shapiro
from statsmodels.tsa.statespace.sarimax import SARIMAX
from sklearn.metrics import mean_squared_error, mean_absolute_error


# In[2]:


# 绘制数据特征(time series, autocorrelation,partial autocorrelation and distribution plots of data)
def plot_data_properties(data, ts_plot_name="Time Series plot"):
    plt.figure(figsize=(16, 4))
    plt.plot(data)
    plt.title(ts_plot_name)
    plt.ylabel('Sales')
    plt.xlabel('Year')
    fig, axes = plt.subplots(1, 3, squeeze=False)
    fig.set_size_inches(16, 4)
    plot_acf(data, ax=axes[0, 0], lags=24)
    plot_pacf(data, ax=axes[0, 1], lags=24)
    sns.distplot(data, ax=axes[0, 2])
    axes[0, 2].set_title("Probability Distribution")


# 数据平稳性(p_val >= 0.05 means the data is not stationary)
def test_stationarity(data):
    p_val = adfuller(data['express'])[1]
    if p_val >= 0.05:
        print("Time series data is not stationary. Adfuller test pvalue={}".format(p_val))
    else:
        print("Time series data is stationary. Adfuller test pvalue={}".format(p_val))


# 季节性分解(时间序列组成部分：趋势，季节性，周期，残差：Trend + Sesonal + Cycle + Residual)
def plot_seasonal_decompose(data, model):
    decomposition = seasonal_decompose(data, model=model)
    decomposition.trend.plot(figsize=(10, 2), title='Trend')
    decomposition.seasonal.plot(figsize=(10, 2), title='Seasonality')
    decomposition.resid.plot(figsize=(10, 2), title='Residuals')
    return decomposition


# Shapiro-Wilk检验，评估数据是否符合正态分布
def shapiro_normality_test(data):
    p_value = shapiro(data)[1]
    if p_value >= 0.05:
        print("Data follows normal distribution: X~N" + str((np.round(np.mean(data), 3), np.round(np.std(data), 3))))
        print("Shapiro test p_value={}".format(np.round(p_value, 3)))
    else:
        print("Data failed shapiro normality test with p_value={}".format(np.round(p_value, 3)))


# 寻找最佳SARIMA模型
def find_best_sarima(train_data, p, q, P, Q, d=1, D=1, s=12):
    best_model_aic = np.Inf
    best_model_bic = np.Inf
    best_model_hqic = np.Inf
    best_model_order = (0, 0, 0)
    models = []
    for p_ in p:
        for q_ in q:
            for P_ in P:
                for Q_ in Q:
                    try:
                        no_of_lower_metrics = 0
                        model = SARIMAX(endog=train_data, order=(p_, d, q_), seasonal_order=(P_, D, Q_, s),
                                        enforce_invertibility=False).fit()
                        models.append(model)
                        if model.aic <= best_model_aic: no_of_lower_metrics += 1
                        if model.bic <= best_model_bic: no_of_lower_metrics += 1
                        if model.hqic <= best_model_hqic: no_of_lower_metrics += 1
                        if no_of_lower_metrics >= 2:
                            best_model_aic = np.round(model.aic, 0)
                            best_model_bic = np.round(model.bic, 0)
                            best_model_hqic = np.round(model.hqic, 0)
                            best_model_order = (p_, d, q_, P_, D, Q_, s)
                            current_best_model = model
                            models.append(model)
                            print("Best model so far: SARIMA" + str(best_model_order) +
                                  " AIC:{} BIC:{} HQIC:{}".format(best_model_aic, best_model_bic, best_model_hqic) +
                                  " resid:{}".format(np.round(np.exp(current_best_model.resid).mean(), 3)))

                    except:
                        pass

    print('\n')
    print(current_best_model.summary())
    return current_best_model, models


# 考虑AR项，进一步优化SARIMAX
def find_sarima_with_ar(models, aic_threshold, mape_threshold):
    tests_score = []
    trains_score = []
    models_order = []
    models_aic = []
    min_mape = mape_threshold
    for model in models:
        if model.aic < aic_threshold:
            model_order = "ar:" + str(model.model_orders['ar']) + " ma:" + str(
                model.model_orders['ma']) + " s_ar:" + str(
                int(model.model_orders['seasonal_ar'] / 12)) + " s_ma:" + str(
                int(model.model_orders['seasonal_ma'] / 12))
            models_order.append(model_order)
            models_aic.append(model.aic)
            train_forecasts = training_data.values[1:].reshape(training_size - 1) - model.resid[1:]
            train_mae = mean_absolute_error(training_data[1:], train_forecasts)
            trains_score.append(np.round(train_mae, 3))
            preds = np.exp(model.predict(start=test_start_date, end=practical_end_date, dynamic=True, typ='levels'))
            test_mape = mean_abs_pct_error(test_data, preds)
            if test_mape < min_mape:
                agile_model_aic = np.round(model.aic, 0)
                agile_model_bic = np.round(model.bic, 0)
                agile_model_hqic = np.round(model.hqic, 0)
                current_agile_model = model
                print("Optimal model so far: " +
                      " AIC:{} BIC:{} HQIC:{}".format(agile_model_aic, agile_model_bic, agile_model_hqic) +
                      " resid:{}".format(np.round(np.exp(current_agile_model.resid).mean(), 3)))
                min_mape = test_mape
            tests_score.append(np.round(test_mape, 3))
    model_properties = {'aic': models_aic, 'model_order': models_order, 'train_score': trains_score,
                        'test_score': tests_score}
    # 绘制新模型效果
    colors = ['g' if x < mape_threshold else 'b' for x in model_properties['test_score']]
    plt.figure(figsize=(20, 6))
    plt.bar(model_properties['model_order'], model_properties['test_score'], color=colors)
    plt.xlabel('Model')
    plt.ylabel('MAPE: %')
    plt.title('MAPE(%) for different model orders. Annotations are AIC values.')
    for i, aic in enumerate(model_properties['aic']):
        plt.annotate(np.round(aic, 0), (model_properties['model_order'][i], model_properties['test_score'][1]))
    plt.xticks(rotation=90)
    # 选择优化后的最佳模型
    print('\n')
    print(current_agile_model.summary())
    return current_agile_model


# 计算平均绝对百分比误差(Mean Absolute Percentage Error, MAPE)
def mean_abs_pct_error(actual_values, forecast_values):
    err = 0
    for i in range(len(forecast_values)):
        err += np.abs(actual_values.values[i] - forecast_values.values[i]) / actual_values.values[i]
    return err[0] * 100 / len(forecast_values)


# 绘制观察最佳模型
def evaluate_model(model):
    plt.scatter(x=log_transformed_data[1:], y=model.resid[1:])
    plt.title('Residuals plot')
    plt.xlabel('Log transformed data')
    plt.ylabel('Residuals')
    # 评估最佳模型的残差数据是否符合正态分布
    shapiro_normality_test(model.resid[1:].drop(index=pd.to_datetime(differed_start_date)))
    # 观察最佳模型的残差数据的自相关性
    plot_acf(model.resid[1:], lags=20)


# 使用测试集预测值
def predict_by_model(model, predict_start_date, predict_end_date, calculate_mape=True):
    model_preds = np.exp(model.predict(start=predict_start_date, end=predict_end_date, dynamic=True, typ='levels'))
    mape = 1
    if calculate_mape:
        mape = np.round(mean_abs_pct_error(test_data, model_preds), 2)
        print("MAPE:{}%".format(mape))
        print("MAE:{}".format(np.round(mean_absolute_error(test_data, model_preds), 2)))
    # 绘制预测结果效果
    model_data = training_data.values[1:].reshape(training_size - 1) - model.resid[1:]
    model_data = pd.concat((model_data, model_preds))
    plt.figure(figsize=(16, 6))
    plt.plot(model_data)
    plt.plot(practical_data[1:])
    plt.legend(['Model Forecast', 'Original Data'])
    print('prediction results are as follows:\n')
    print(model_preds)
    return mape


# In[3]:


# 读取数据
original_data = pd.read_csv(filepath_or_buffer='express_predict.csv', index_col='date', parse_dates=True)
print(original_data.head())
print(original_data.info())

# In[4]:


# 标记数据集起止时间
dataset_start_date = '2014-01-01'
dataset_end_date = '2029-12-01'

# In[5]:


# 设置实际数据集
practical_end_date = '2019-12-01'
practical_data = original_data[:practical_end_date]
practical_size = len(practical_data)

# In[6]:


# 绘制原始数据特征
plot_data_properties(practical_data, 'monthly express data from 2014-01-01 to 2019-12-01')

# In[7]:


# 绘制相关性
fig, axes = plt.subplots(1, 2, squeeze=False)
fig.set_size_inches(14, 4)
axes[0, 0].scatter(x=practical_data[1:], y=practical_data.shift(1)[1:])
axes[0, 1].scatter(x=practical_data[12:], y=practical_data.shift(12)[12:])
axes[0, 0].set_title('Correlation of y_t and y_t-1')
axes[0, 1].set_title('Correlation of y_t and y_t-12')

# In[8]:


# 数据平稳性
test_stationarity(practical_data)

# In[9]:


# 设置测试数据集
test_start_date = '2019-06-01'
# 训练数据集
training_data = practical_data[:test_start_date]
training_size = len(training_data)
# 测试数据集
test_data = practical_data[test_start_date:]

# In[10]:


# 绘制季节分解结果
decomposition = plot_seasonal_decompose(training_data, 'multiplicative')

# In[11]:


# 绘制趋势(接近于年度平均)
ma_12 = training_data.rolling(window=12).mean()
plt.figure(figsize=(12, 4))
plt.plot(ma_12)
plt.title('MA_12')

# In[12]:


# 绘制季节, S=Y/T
seasonal_component = training_data / decomposition.trend
plt.figure(figsize=(12, 4))
plt.plot(seasonal_component)
plt.scatter(x='2015-11-01', y=seasonal_component.loc['2015-11-01'], marker='D', s=50, color='r')
plt.scatter(x='2016-02-01', y=seasonal_component.loc['2016-02-01'], marker='D', s=50, color='g')
plt.title('S=Y/T')

# In[13]:


# 绘制残差, R=Y/(S*T)
residual_component = training_data / (decomposition.trend * decomposition.seasonal)
plt.figure(figsize=(12, 4))
plt.plot(residual_component)
plt.title('R = Y / (S*T)')

# In[14]:


# 历年数据观察
plt.figure(figsize=(16, 8))
plt.grid(which='both')
years = int(np.round(len(training_data) / 12))
for i in range(years):
    index = training_data.index[i * 12:(i + 1) * 12]
    plt.plot(training_data.index[:12].month_name(), training_data.loc[index].values)
    plt.text(y=training_data.loc[index].values[11], x=11, s=training_data.index.year.unique()[i])
plt.legend(training_data.index.year.unique(), loc=0)
plt.title('express data over the years')

# In[15]:


# 对数化处理数据并测试平稳性
log_transformed_data = np.log(training_data)
plot_data_properties(log_transformed_data, 'Log tranformed training data')
test_stationarity(log_transformed_data)

# In[16]:


# 设置差分下的起始时间
differed_start_date = '2014-02-01'

# In[17]:


# 一阶差分(去除趋势影响)处理数据并测试平稳性
logged_diffed_data = log_transformed_data.diff()[1:]
plot_data_properties(logged_diffed_data, 'Log transformed and differenced data')
test_stationarity(logged_diffed_data)

# In[18]:


# 十二阶差分(去除季节影响)处理数据并测试平稳性
seasonally_diffed_data = logged_diffed_data.diff(12)[12:]
plot_data_properties(seasonally_diffed_data, 'Log transofrmed, diff=1 and seasonally differenced data')
test_stationarity(seasonally_diffed_data)

# In[19]:


# 评估处理后的数据是否符合正态分布
shapiro_normality_test(seasonally_diffed_data.express)

# In[20]:


# 训练出最佳模型，并显示最佳模型参数(最低的AIC，BIC，HQIC)
best_model, models = find_best_sarima(train_data=log_transformed_data, p=range(3), q=range(3), P=range(3), Q=range(3))

# In[21]:


# 评估最佳模型
evaluate_model(best_model)

# In[22]:


# 根据最佳模型预测测试集
mape = predict_by_model(best_model, test_start_date, practical_end_date)

# In[29]:


# 根据优化模型预测未来数据
predict_by_model(best_model, test_start_date, dataset_end_date, calculate_mape=False)

# In[24]:


# 根据AR项优化SARIMAX模型，并显示最佳模型参数
agile_model = find_sarima_with_ar(models, best_model.aic + 15, mape)

# In[25]:


# 评估优化模型
evaluate_model(agile_model)

# In[26]:


# 根据优化模型预测测试集
predict_by_model(agile_model, test_start_date, practical_end_date)

# In[27]:


# 根据优化模型预测未来数据
predict_by_model(agile_model, test_start_date, dataset_end_date, calculate_mape=False)
