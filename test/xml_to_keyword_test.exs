defmodule XmlToKeywordTest do
  use ExUnit.Case
  doctest XmlToKeyword

  test "Convert an easy structure" do
    xml = XmlToKeyword.convert("<foo>bar</foo>")
    assert xml == {:ok, {:foo, [:foo, "bar"]}}
  end
  test "Convert a structure with attributes" do
    xml = XmlToKeyword.convert("<body><foo at='value' from='re-value'>bar</foo></body>")
    assert xml == {:ok, {:body, [:body, [{:foo, %{at: "value", from: "re-value"}, "bar"}]]}}
  end
  test "Convert a structure a little more complex without attributes" do
    xml = XmlToKeyword.convert("<body><foo><do><redo>bar</redo></do></foo></body>")
    assert xml == {:ok, {:body, [:body, [foo: [do: [redo: "bar"]]]]}}
  end
  test "Convert a structure a little more complex with attributes" do
    xml = XmlToKeyword.convert("<body><foo at='value' from='re-value'><do><redo at='value2'>bar</redo></do></foo></body>")
    assert xml == {:ok, {:body, [:body, [{:foo, %{at: "value", from: "re-value"}, [do: [{:redo, %{at: "value2"}, "bar"}]]}]]}}
  end
  test "Convert a structure with the xml header" do
    xml = XmlToKeyword.convert("<?xml version='1.0' encoding='UTF-8'?><body><foo at='value' from='re-value'><do><redo at='value2'>bar</redo></do></foo></body>")
    assert xml == {:ok, {:body, [:body, [{:foo, %{at: "value", from: "re-value"}, [do: [{:redo, %{at: "value2"}, "bar"}]]}]]}}
  end
  test "Convert from file" do
    {result, content} = File.read "./test/templates/template.xml"
    xml = XmlToKeyword.convert(content)
    assert xml == {:ok, {:body, [:body, [{:foo, %{at: "value", from: "re-value"}, "\n    bar\n  "}]]}}
  end
end
