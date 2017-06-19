class CatsController < ApplicationController
  def index
    @cats = Cat.all
  end

  def show

  end
end
