class Category < ApplicationRecord
    has_one :post
    validates :name,  presence: true
end
