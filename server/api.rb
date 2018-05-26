#coding: utf-8

module Api
  def api_send_message(params)
    line = self.web_server.new
    line[:desc]      = params['message']
    line[:remote_ip] = params['ip']
    line.save_changes
    resp = {
        'code' => 0,
        'msg'  => '',
        'resp' => []
    }
    resp.to_json
  end

  def api_get_message_list(params)
    message_list = self.web_server.order(:create_time).map do |e|
      e.to_hash
    end
    resp = {
        'code' => 0,
        'msg'  => '',
        'resp' => message_list
    }
    resp.to_json
  end

end
