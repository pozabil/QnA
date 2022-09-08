module AttachmentsHelper
  SHORT_FILENAME_LENGTH = 30

  def short_filename(file)
    if file.filename.to_s.length > SHORT_FILENAME_LENGTH
      file.filename.to_s[0, (SHORT_FILENAME_LENGTH - 2 - file.filename.extension_with_delimiter.length)] + '..' + file.filename.extension_with_delimiter
    else
      file.filename.to_s
    end
  end

  def remove_attachment(file)
    link_to t('.remove'),
            attachment_path(file),
            method: :delete,
            remote: true
  end
end
