# CS1555 Term Project

An electronic auctioning system, similar to `ebay.com` driven by Oracle, Java and JDBC.

## Concerns

* When browsing products (1.a), should products categorized under a child category be dispalyed?
* When outputing the top k highest volulme root categories (2.d.ii), do we factor in products that are categorized under the root? If so, then it is not possible to solely use the product_count function (because a product might exist in multiple categories, and we don't want to count it twice).
* Should product statistics (2.c) only include 'sold' and 'underaction' products? Right now it includes all products (either sold or not sold).
* Should search (1.b) output any other columns besides auction_id, name and description?
* Are a bidder's friends (1.f) actually people who bid on _all_ of the same items or just _some_ of them?
