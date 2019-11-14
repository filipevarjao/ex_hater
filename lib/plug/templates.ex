defmodule Plug.Templates do
  @upload_html """
  <!DOCTYPE html>
  <html>
  <body>
  <h1>Upload a json file with the chatbot conversation:</h1>
  <form action="/upload" enctype="multipart/form-data" method="POST">
    Select a file: <input type="file" name="uploaded_file"><br><br>
    <input type="submit">
  </form>
  </body>
  </html>
  """

  def upload_html, do: @upload_html

  def list(content) do
    list = ""

    list =
      for line <- content do
        number = Enum.at(line, 0)
        body = Enum.at(line, 1)
        list <> "<li><a href='show/#{number}'>#{number}:</a> #{body}</li>"
      end

    """
    <!DOCTYPE html>
    <html>
    <body>
    <h1>List:</h1>
      <ul>
        #{list}
      </ul>
      <br></br>
      <br></br>
      <br></br>
      <div><a href='upload'>Upload a file.</a></div>
    </body>
    </html>
    """
  end
end
