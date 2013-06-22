module PaginateCached

  # Arguments:
  # This function takes :page as the page number, and it is required.
  # The number of results is passed in as :number_of_results. It defaults to 20.
  # The variable used to hold the current state in the pagination should be placed 
  # in the :search_id variable.
  #
  # The actual code which produces the result is passed in as a block.
  #
  # Results:
  # This returns a hash in which :results will hold the results, :search_id will hold the search id, 
  # next_page: will hold the new page number, and has_more_results will hold whether there are more results.
  #
  def paginate_cached args={}
        page = args[:page] or raise "Page number must be defined."
        number_of_results = args[:number_of_results] || 25
        search_id = args[:search_id]
        offset = (page-1)*number_of_results

        unless search_id and results = Rails.cache.read(search_id) then
              results = yield
              search_id = "#{results.hash}#{Time.now.to_i}"
              Rails.cache.write search_id, results, expires_id: 15.minutes
        end

        return {
                results: results[offset, number_of_results],
                search_id: search_id, 
                next_page: page+1, 
                has_more_results: results[((page)*number_of_results)+1] != nil
               }

   end

  ActionController::Base.send :include, PaginateCached

end
