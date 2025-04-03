# frozen_string_literal: true

class DirectMessageThreadsController < ApplicationController
  def index
    render Views::DirectMessageThreads::Index.new
  end

  def show
    render Views::DirectMessageThreads::Show.new
  end
end
