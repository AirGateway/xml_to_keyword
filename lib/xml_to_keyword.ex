defmodule XmlToKeyword do
  require Record

  Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText,    Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")

  def convert(xml) do
    try do
      {doc, _} = "<excipient>#{Regex.replace(~r/<\?xml [\S\s]*\?>/s, xml, "")}</excipient>" |> :binary.bin_to_list |> :xmerl_scan.string
      [elements] = doc
      |> get_root_path
      |> :xmerl_xpath.string(doc)
      |> Enum.map(fn(element) -> parse(xmlElement(element, :content)) end)

      data = [{get_root_name(doc), elements}][:excipient] |> Enum.at(0) |> data_to_list
      {:ok, data}
    catch
      :fatal, :expected_element_start_tag -> {:error, 400, "Empty XML message"}
      _, _ -> {:error, 400, "Fatal error parsing XML message"}
    end
  end

  defp data_to_list({father, attr, body}), do: {father, [father, attr, body]}
  defp data_to_list({father, body}), do: {father, [father, body]}
  defp parse(node) do
    cond do
      Record.is_record(node, :xmlElement) ->
        name    = xmlElement(node, :name)
        content = xmlElement(node, :content)
        case xmlElement(node, :attributes) do
          [] ->
            [{name, parse(content)}]
          attrs ->
            [{name, attrs |> parse_attrs |> Map.new, parse(content) }]
        end

      Record.is_record(node, :xmlText) ->
        xmlText(node, :value) |> to_string

      is_list(node) ->
        case Enum.map(node, &(parse(&1))) do
          [text_content] when is_binary(text_content) ->
            text_content
          elements ->
            Enum.reduce(elements, [], fn(x, acc) ->
              if is_list(x) do
                acc ++ x
              else
                acc
              end
            end)
        end
      true -> IO.inspect "Error in XmlToKeyword not supported"
    end
  end

  defp get_root_name(doc), do: doc |> xmlElement(:name)
  defp get_root_path(doc), do: '//#{get_root_name(doc)}'
  defp parse_attrs(attrs) do
    Enum.map(attrs, fn(attr) ->
      { xmlAttribute(attr, :name), to_string  xmlAttribute(attr, :value) }
    end)
  end
end
