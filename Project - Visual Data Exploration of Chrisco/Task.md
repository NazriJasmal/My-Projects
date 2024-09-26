## Visual Data Exploration of ChrisCo

Your task is to carry out a visual data exploration for ChrisCo, a fictional and a very successful company that manages a range of retail outlets across the UK. ChrisCo collects a huge amount of data about individual customers visiting its outlets using its loyalty card scheme but this customer data has been aggregated/averaged to give information about the company’s 45 outlets, each identified by a unique 3 letter code (e.g. ABC, XYZ, etc). 

You will be using a Python Notebook, either in Colab or Jupyter, to carry out this exploration

To explore the data, ChrisCo’s daily customer data visiting its outlet and the overall performance of each outlet, are provided as the data sources in CSV format. We need to use basic Pandas functions such as head(), info(), and describe() to explore the data to get an initial understanding of its structure, size, and content. Then, visualize the data using visualization libraries such as Seaborn, Matplotlib or other to create visualizations such as scatter plots, bar charts, and line charts to identify patterns, trends, correlations, and insights in the data.

## Attributes of the Dataset

We need to explore 5 different CSV datasets that contain the daily customer data visiting each outlet and the overall performance of each outlet, such as outlet marketing, outlet overheads, outlet size, and outlet staff.
DailyCustomers.csv - Contains the number of daily customers each store had over a one-year period.
StoreMarketing.csv - Contains the amount of money each store spent annually for marketing.
StoreOverheads.csv - Contains the amount of money each store spent annually for non-essential purposes.
StoreSize.csv - Contains the size (floor space) of each store in square meters.
StoreStaff.csv - Contains the number of staff members employed at each store.

• Daily Customer Data: This dataset contains information on the number of customers visiting each outlet each day in the year 2021

• Outlet Marketing: This dataset shows the amount spent by each outlet in marketing.

• Outlet Overheads: This dataset contains the amount of money each outlet spent annually for non-essential purposes, ie. overhead expense.

• Outlet Size: This dataset contains information on the extent of a company’s various outlets in square meters.

• Outlet Staff: This dataset contains data on the number of employees working in each outlet.

The data needs to be combined into two data frames: one containing ‘Daily Customer Data’ and one row for each date, and the other containing ‘Summary Data’ and one row for each outlet, assembled from all of the CSV files, including the daily customer data.
