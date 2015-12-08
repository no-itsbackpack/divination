module Divination
  module PageScopeMethods
    # Specify the <tt>per_page</tt> value for the preceding <tt>page</tt> scope
    #   Model.page(3).per(10)
    def per(num)
      if (n = num.to_i) <= 0
        self
      elsif max_per_page && max_per_page < n
        limit(max_per_page)
      else
        limit(n)
      end
    end

    # TODO: are these 2 methods triggering multiple db hits? want to run this on cached result
    def next_max_id
      # all[per_page - 1]
      @_next_max_id ||= all.last.try(:id)
    end

    def next_url request_url
      after_url(request_url, next_cursor)
    end

    def after_url request_url, cursor
      base, params = url_parts(request_url)
      params.merge!(Divination.config.after_param_name.to_s => cursor) unless cursor.nil?
      params.to_query.length > 0 ? "#{base}?#{CGI.unescape(params.to_query)}" : base
    end

    def url_parts request_url
      base, params = request_url.split('?', 2)
      params = Rack::Utils.parse_nested_query(params || '')
      params.stringify_keys!
      params.delete('before')
      params.delete('after')
      [base, params]
    end

    def direction
      return :after if prev_cursor.nil? && next_cursor.nil?
      @_direction ||= prev_cursor < next_cursor ? :after : :before
    end

    def pagination request_url
      h = { next_max_id: next_cursor }
      h[:next_url] = next_url(request_url) unless next_max_id.nil?
      h
    end
  end
end
