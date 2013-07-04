module ItemsHelper

	def categoryList
		@itemCategory = Category.all.map { |category| [category.nameCategory, category.nameCategory]}
    @itemCategory = @itemCategory + [['All', 'All']]
  end
end
