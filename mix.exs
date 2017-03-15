defmodule XmlToKeyword.Mixfile do
  use Mix.Project

  def project do
    [app: :xml_to_keyword,
     version: "0.0.4",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     package: [
     licenses: ["Free licenses"],
       maintainers: ["Zaali Kavelashvili", "zaali@live.com", "Eloy Fernández"],
       links: %{"Github" => "https://github.com/eloyucu/xml_to_keyword"}
     ],
     description: """
       This is an Elixir package that can convert xml into Elixir's Keyword List, which is compilable with XmlBuilder (joshnuss/xml_builder) package
       """
   ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev}]
  end
end
