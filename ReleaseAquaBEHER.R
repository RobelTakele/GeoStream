#!/usr/local/bin/Rscript
###############################################################################

rm(list = ls())

## ***** Set AquaBEHER project dir:

setwd("/home/robel/gitProj/AquaBEHER/")

# usethis::use_lifecycle_badge("stable")
#  usethis::create_github_token()

###############################################################################
###############################################################################

 ## 1. Update Documentation

devtools::document()
devtools::build_manual()

 ## 2. Update DESCRIPTION File:
      # Version: Increment the version number according to semantic versioning
      # Authors/Maintainers:
      # Dependencies: Check and update any package dependencies. Verify that
                    # all dependencies are correctly listed in the `DESCRIPTION`

 AqB.desc <- desc::description$new()
 AqB.desc$set_version("1.4.0")
 AqB.desc$reformat_fields()
 AqB.desc$normalize()
 AqB.desc$print()
 AqB.desc$write()

 depUse <- depcheck::checkPackageDependencyUse(include_suggests = TRUE,
                                               verbose = TRUE)
 summary(depUse)

 depUseProj <- depcheck::checkProjectDependencyUse(recursive = TRUE,
                                                   verbose = TRUE)
 summary(depUseProj)

 devtools::document()
 devtools::build_manual()

 devtools::check()

 ## 3. Update README and NEWS:

 pkgdown::build_news()

 devtools::build_readme()

 ## 4. Update Vignettes:

  devtools::build_vignettes()

## ****************************************************************************

  devtools::dev_sitrep()

  pkgdown::build_news()
  devtools::build_readme()
  devtools::build_vignettes()
  devtools::document()
  devtools::build_manual()
  devtools::show_news()
  devtools::run_examples()
  devtools::build_site()

  devtools::test()
  devtools::check()
  devtools::release_checks()

 ## 5. Check Code for Issues:

  styler::style_pkg()
  lintr::lint_package()
  devtools::lint()

  urlchecker::url_check()

  spelling::spell_check_package(vignettes = TRUE, use_wordlist = TRUE)

 # revdepcheck::revdep_check()

  devtools::check()

  ## 6. Build and Install the Package:

   devtools::install()

   devtools::build()

   ## 7. Validate the Package:

          # Ensure Compliance with CRAN Policies:

   devtools::check(remote = TRUE,
                   document = TRUE,
                   manual = TRUE,
                   cran = TRUE,
                   force_suggests = TRUE,
                   run_dont_test = TRUE,
                   vignettes = TRUE)

   rcmdcheck::rcmdcheck( )
   rcmdcheck::rcmdcheck(args = "--as-cran")
   devtools::check_win_devel()


   # Run R CMD check

   ## 8. Commit Changes:

       #  gh auth login
       #  git add . && git commit -m "New release"
       #  git push -u origin master

   ## 9. Create a GitHub Release:

   #    git tag -a v1.4.0 -m "Minor release"
   #    git push origin --tags

  # usethis::use_github_release(publish = TRUE)

   devtools::install_github("RobelTakele/AquaBEHER")



   # git fetch origin
   # git rebase origin/main
   # git rebase --continue
   # git push -f origin master


##############################################################################
 ## ***** Last commit

#   gh auth login
#   git add . && git commit -m "Issues with README fixedUP"
#   git push -u origin master

##############################################################################
 ## *****

   devtools::check()


   devtools::check_win_devel()
   devtools::check_mac_release()


   devtools::build()

###
   devtools::release()

   devtools::submit_cran()

##############################################################################
 ## ***** pull request for open-sustainable-technology repo:

 ## >>>>> Fork the open-sustainable-technology repo:

 ## >>>>> Clone Your Fork Locally:

 #   git clone https://github.com/RobelTakele/open-sustainable-technology.git
 #   cd open-sustainable-technology

 ## >>>>> Add the original open-sustainable-technology repo as a remote:

 #   git remote add upstream https://github.com/protontypes/open-sustainable-technology.git
 #   git fetch upstream

 ## >>>>> Sync Your Fork:

   #   git fetch upstream
   #   git checkout main
   #   git merge upstream/main

 ## >>>>>  Create a New Branch:

 #   git checkout -b Update-AquaBEHER
 #   git add . && git commit -m "Update the description of AquaBEHER"
 #   git push origin Update-AquaBEHER

 ## >>>>> Create a Pull Request (PR)

#    Go to the original repository on GitHub.
#    GitHub will prompt you to create a pull request after you push the new branch.
#    Select the base repository (original repository) and branch you want to merge into
#    (usually main or develop), and the head repository (your fork and branch).
#    Add a title and description for your PR explaining the changes.
#    Submit the pull request.

## >>>>> Merge the PR

## Clean Up Your Branch

   #   git checkout main
   #   git pull Update-AquaBEHER
   #   git branch -d Update-AquaBEHER
   #   git push origin --delete Update-AquaBEHER

###############################################################################
###############################################################################
#              >>>>>>>>>>   End of code   <<<<<<<<<<                          #
###############################################################################
###############################################################################
