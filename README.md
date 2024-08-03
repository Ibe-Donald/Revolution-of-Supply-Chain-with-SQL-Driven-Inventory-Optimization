# Revolution-of-Supply-Chain-with-SQL-Driven-Inventory-Optimization
The primary objectives of this project are to implement a sophisticated inventory optimization system utilizing MySQL and enable data-driven decision-making in inventory management by leveraging MySQL analytics to reduce costs and enhance customer satisfaction.

In this analysis, I explored and cleaned our datasets from tech_electro schema to gain insights into the inventory data, sales data, product information, and external factors affecting our business. The goal was to understand the trends in sales, identify the factors contributing to these trends, and provide data-driven recommendations for optimizing inventory management.

Data Exploration and Cleaning
---
I began by examining the structure of the datasets: external_factors, sales_data, and product_information. After understanding the columns and their data types, I performed several data cleaning operations, including:

Converting date columns to the correct DATE format.

Modifying numeric columns to appropriate precision and scale.

Updating categorical data types to ENUM for better constraint and clarity.

Identifying and handling missing values.

Detecting and removing duplicate entries.

Data Integration
---
I created integrated views to combine relevant information from different tables. This integration allowed me to perform comprehensive analysis by joining sales_data with product_information and further integrating with external_factors to form a consolidated inventory_data view.

Descriptive Analysis
---
Average Sales
---
I calculated the average sales for each product and found that Product_ID 2010 had the highest average sales of 19,669. This insight is critical for inventory optimization and demand forecasting.

Daily Total Sales
---
I analyzed the total sales for each day, which helps in understanding peak sales periods and planning inventory accordingly.

Sales Year with Most Sales
---
The analysis revealed that the year 2020 recorded the highest number of sales with a total of 121 sales. This historical data helps in year-over-year comparison and trend analysis.

Year with Most Sales Amount
---
I observed that 2020 also had the highest sales amount of 661,555.21, indicating not just a high volume of sales but also a high value.

Most Purchased Product
---
Smartphones emerged as the most purchased product category, highlighting the need to maintain a robust inventory for smartphones to meet customer demand.

Role of Promotions in Sales
---
By analyzing the impact of promotions on sales, I discovered that promotions significantly contributed to the increase in sales across different product categories. This insight can guide future promotional strategies.

Revenue Generation by Product Category
---
Although smartphones had the highest sales count, electronics generated the most revenue, suggesting a focus on high-margin electronics can boost overall profitability.

Monthly Sales Trends for Home Appliances in 2022
---
I noticed a spike in the purchase of home appliances in August 2022. Further investigation showed that promotions played a vital role in this increase, emphasizing the effectiveness of targeted promotions.

Recommendations
---
**Optimize Inventory for High-Demand Products:** Maintain higher stock levels for smartphones and electronics, as they are the most purchased and highest revenue-generating categories, respectively.

**Leverage Promotions:** Implement strategic promotions, especially during peak sales periods. The significant impact of promotions on sales, particularly in August for home appliances, underscores the importance of well-timed promotional campaigns.

**Demand Forecasting:** Use historical sales data to forecast demand, especially focusing on high-sales years like 2020, to prepare for similar trends in the future.
Prioritize inventory for high-margin products like electronics to maximize profitability. Balancing between high-sales volume and high-margin products can optimize overall revenue.

**Analyze Sales Trends:** Regularly analyze sales trends across different product categories and time periods to adapt inventory levels and promotional strategies accordingly.

Conclusion
---
By leveraging data-driven insights, Tech Electro can optimize inventory management, reduce costs, enhance customer satisfaction, and ultimately drive profitability. The comprehensive analysis of sales data, product information, and external factors provides a solid foundation for strategic decision-making in inventory management.
