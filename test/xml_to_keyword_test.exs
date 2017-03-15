defmodule XmlToKeywordTest do
  use ExUnit.Case
  doctest XmlToKeyword

  test "Convert an easy structure" do
    xml = XmlToKeyword.convert("<foo>bar</foo>")
    assert xml == [foo: "bar"]
  end
  test "Convert a structure with attributes" do
    xml = XmlToKeyword.convert("<body><foo at='value' from='re-value'>bar</foo></body>")
    assert xml == [body: [{:foo, %{at: "value", from: "re-value"}, "bar"}]]
  end
  test "Convert a structure a little more complex without attributes" do
    xml = XmlToKeyword.convert("<body><foo><do><redo>bar</redo></do></foo></body>")
    assert xml == [body: [{:foo, nil, [{:do, nil, [{:redo, nil, "bar"}]}]}]]
  end
  test "Convert a structure a little more complex with attributes" do
    xml = XmlToKeyword.convert("<body><foo at='value' from='re-value'><do><redo at='value2'>bar</redo></do></foo></body>")
    assert xml == [body: [{:foo, %{at: "value", from: "re-value"}, [{:do, nil, [{:redo, %{at: "value2"}, "bar"}]}]}]]
  end
  test "Convert from file" do
    {result, content} = File.read "./test/templates/template.xml"
    xml = XmlToKeyword.convert(content)
    IO.inspect xml
    #assert xml == [body: [{:foo, %{at: "value", from: "re-value"}, "bar"}]]
  end
end
