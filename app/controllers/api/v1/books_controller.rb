module Api
    module V1
        class BooksController < ApplicationController
            ALLOWED_DATA = %[title description rating].freeze
            def index
                books = Book.all
                render json: books
            end

            def show
                book = Book.find(params[:id])
                render json: book, except: :title
            end

            def create
               data = json_payload.select{|k| ALLOWED_DATA.include?(k)}
               book = Book.new(data)
                if book.save
                   render json: book, status: :created
                else
                   render json: book.errors, status: :unprocessable_entity
                end
            end

            def update
                book = Book.find(params[:id])
                newData = json_payload.select{|k| ALLOWED_DATA.include?(k)}
                Rails.logger.debug("My object: #{newData.inspect} #{newData["rating"].inspect}")
                if book.update(title: newData["title"], description: newData["description"], rating: newData["rating"])
                    render json: newData, status: :ok
                else
                    render json: book.errors, status: :unprocessable_entity
                end
            end

            def destroy
                book = Book.find(params[:id])
                puts "#{book}"
                book.destroy
                render json: book, status: :no_content
            end
        end
    end
end
