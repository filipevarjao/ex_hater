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
      <div><a href='upload'>Upload a file</a></div>
    </body>
    </html>
    """
  end

  def timeline(content) do
    list = ""

    list =
      for div <- content do
        id = div.id_str
        created_at = div.created_at
        retweet = div.retweet_count
        like = div.favorite_count

        text =
          if div.full_text do
            div.full_text
          else
            div.text
          end

        list <>
          "<tr><td><a href='tone/#{id}'>#{text}</a></td><td>#{like}</td><td>#{retweet}</td><td>#{
            created_at
          }</td></tr>"
      end

    """
    <!DOCTYPE html>
    <html>
    <head>
    <style>
    table {
      font-family: arial, sans-serif;
      border-collapse: collapse;
      width: 100%;
    }

    td, th {
      border: 1px solid #dddddd;
      text-align: left;
      padding: 8px;
    }

    tr:nth-child(even) {
      background-color: #dddddd;
    }
    </style>
    </head>
    <body>

    <h2>Twitter</h2>

    <table>
      <tr>
        <th>Text</th>
        <th>Favorite count</th>
        <th>Retweet count</th>
        <th>Created at</th>
      </tr>
      #{list}
    </table>
    </body>
    </html>
    """
  end
end
