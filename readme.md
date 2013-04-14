# CS 1573 Term Project

An electronic auctioning system, similar to `ebay.com` driven by Oracle, Java and JDBC.

## Concerns

* When browsing products (1.a), should products categorized under a child category be dispalyed?
* When outputing the top k highest volulme root categories, do we factor in products that are categorized under the root? If so, then it is not possible to solely use the product_count function (because a product might exist in multiple categories, and we don't want to count it twice).