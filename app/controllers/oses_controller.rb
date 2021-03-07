# frozen_string_literal: true

class OsesController < ApplicationController
  layout "detail"

  def index
    @site = current_user.sites.find_by!(uuid: params[:site_id])

    base = QueryBuilder.call(Hyper::Event, @site, params).result
    current_scope = QueryBuilder.call(Hyper::Event, @site, period: "realtime").result
    @current_visitors_count = current_scope.distinct.count(:client_id)
    @top_oses = base
      .where(event_name: "page_view")
      .select("os, count(distinct client_id) as visitors_count, count(*) as count, count(distinct session_id) as sessions_count")
      .group("site_id, os").order("2 desc").limit(100)
  end
end
