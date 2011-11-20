module SecondMate

  class CombinedLogger < Rack::CommonLogger
    FORMAT = %{%s - %s [%s] "%s %s%s %s" %d %s %0.4f "%s"\n}

    def log(env, status, header, began_at)
      now = Time.now
      length = extract_content_length(header)

      logger = @logger || env['rack.errors']
      logger.write FORMAT % [
        env['HTTP_X_FORWARDED_FOR'] || env['REMOTE_ADDR'] || '-',
        env['REMOTE_USER'] || '-',
        now.strftime('%d/%b/%Y %H:%M:%S'),
        env['REQUEST_METHOD'],
        env['PATH_INFO'],
        env['QUERY_STRING'].empty? ? '' : '?'+env['QUERY_STRING'],
        env['HTTP_VERSION'],
        status.to_s[0..3],
        length,
        now - began_at,
        header['second_mate.response_file'] || 'NONE'
      ]
    end

  end

end
