# CS1555 Term Project

An electronic auctioning system, similar to `ebay.com` driven by Oracle, Java and JDBC.

## Concerns

* When outputing the top k highest volulme root categories (2.d.ii), do we factor in products that are categorized under the root? If so, then it is not possible to solely use the product_count function (because a product might exist in multiple categories, and we don't want to count it twice).
*		strictly root categories. example given: don't include books that are fantasy or computer science books -- only books
* Are a bidder's friends (1.f) actually people who bid on _all_ of the same items or just _some_ of them?
*		all of them. she didn't really know/suggest a good way to do it. she was just reading off the project descirption and didn't know specifics