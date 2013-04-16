# CS1555 Term Project

An electronic auctioning system, similar to `ebay.com` driven by Oracle, Java and JDBC.

## Concerns

* When outputing the top k highest volulme root categories (2.d.ii), do we factor in products that are categorized under the root? If so, then it is not possible to solely use the product_count function (because a product might exist in multiple categories, and we don't want to count it twice).
*		strictly root categories. example given: don't include books that are fantasy or computer science books -- only books
* Should product statistics (2.c) only include 'sold' and 'underaction' products? Right now it includes all products (either sold or not sold).
*		yes sold and underacution only
* Should search (1.b) output any other columns besides auction_id, name and description?
*		she didn't really care. these three are fine
* Are a bidder's friends (1.f) actually people who bid on _all_ of the same items or just _some_ of them?
*		all of them. she didn't really know/suggest a good way to do it. she was just reading off the project descirption and didn't know specifics
* Should users be able to set the minimum price of their product when putting it up for auction (1.c)?
*		no it doesn't matter
* Should users only be able to sell (1.e) their products that are 'closed'? How should a seller choose which product to sell? What happens when nobody has bid on a seller's product?
*		just have a loop going through and checking for multiple products ending. if there are no bids then state that and set to to withdrawn