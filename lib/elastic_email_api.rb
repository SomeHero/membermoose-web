require 'net/http'
require 'uri'

USERNAME = 'c21a64b4-d891-44e4-890d-27f7902d3bab'
API_KEY = 'c21a64b4-d891-44e4-890d-27f7902d3bab'
API_URI = URI.parse( 'http://api.elasticemail.com/mailer/send' )
SUCCESS_MATCH_PATTERN = '^[0-9|a-f]{8}-[0-9|a-f]{4}-[0-9|a-f]{4}-[0-9|a-f]{4}-[0-9|a-f]{12}$'
ERROR_MATCH_PATTERN = '^Error:'

class ElasticEmailApi

  class << self

    def send_email(to_addr, subject, template_name, from_addr, from_name, merge_fields, reply_to_email="", reply_to_name="", channel="", time_offset_minutes = 0)
      Rails.logger.debug 'Attempting to post to Elastic Email'

      msg_info = {
        'username' => USERNAME,
        'api_key' => API_KEY,
        'from' => from_addr,
        'from_name' => from_name,
        'to' => to_addr,
        'subject' => subject,
        'template' => template_name,
        'reply_to' => reply_to_email,
        'reply_to_name' => reply_to_name,
        'channel' => channel,
        'time_offset_minutes' => time_offset_minutes
      }
      merge_fields.each do |key,value|
        msg_info[key] = value
      end

      Rails.logger.debug msg_info

      begin
        Net::HTTP.post_form(API_URI, msg_info).body
      rescue StandardError => e
        e.message
      end
    end

  end

end
