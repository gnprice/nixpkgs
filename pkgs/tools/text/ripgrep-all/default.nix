{ stdenv, lib, fetchFromGitHub, rustPlatform, makeWrapper, ffmpeg
, pandoc, poppler_utils, ripgrep, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "ripgrep-all";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "phiresky";
    repo = pname;
    rev = version;
    sha256 = "0fxvnd8qflzvqz2181njdhpbr4wdvd1jc6lcw38c3pknk9h3ymq9";
  };

  cargoSha256 = "1jcwipsb7sl65ky78cypl4qvjvxvv4sjlwcg1pirgmqikcyiiy2l";
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = lib.optional stdenv.isDarwin Security;

  postInstall = ''
    wrapProgram $out/bin/rga \
      --prefix PATH ":" "${lib.makeBinPath [ ffmpeg pandoc poppler_utils ripgrep ]}"
  '';

  meta = with stdenv.lib; {
    description = "Ripgrep, but also search in PDFs, E-Books, Office documents, zip, tar.gz, and more";
    longDescription = ''
      Ripgrep, but also search in PDFs, E-Books, Office documents, zip, tar.gz, etc.

      rga is a line-oriented search tool that allows you to look for a regex in
      a multitude of file types. rga wraps the awesome ripgrep and enables it
      to search in pdf, docx, sqlite, jpg, movie subtitles (mkv, mp4), etc.
    '';
    homepage = https://github.com/phiresky/ripgrep-all;
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ zaninime ];
    platforms = platforms.all;
  };
}