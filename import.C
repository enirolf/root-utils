#include <iostream>
#include <string>

#include <ROOT/RNTupleImporter.hxx>

using ROOT::Experimental::RNTupleImporter;

void import(std::string sourcePath, std::string targetPath, int compression = 505) {
  gErrorIgnoreLevel = kError;

  auto importer = RNTupleImporter::Create(sourcePath, "CollectionTree", targetPath);
  importer->SetIsQuiet(true);
  importer->SetConvertDotsInBranchNames(true);
  auto writeOptions = importer->GetWriteOptions();
  writeOptions.SetCompression(compression);
  importer->SetWriteOptions(writeOptions);

  std::cout << "Importing to " << targetPath << "..." << std::endl;
  importer->Import();
}
