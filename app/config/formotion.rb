module Formotion
  class Form < Formotion::Base
    def tableView(tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
      cell.backgroundColor = UIColor.clearColor
      cell.textLabel.font = UIFont.fontWithName('Roboto-Bold', size: 15)
    end
  end

  class FormController
    ROW_OPTIONS = {
      auto_correction: 'no',
      auto_capitalization: 'none',
      selection_style: UITableViewCellSelectionStyleNone,
      font: {
        name: 'HelveticaNeue-Thin',
        size: 17
      }
    }

    def performHousekeepingTasks
      self.view.setBackgroundColor(UIColor.whiteColor)
      self.view.backgroundView = nil
    end

    def mergeRowOptions(options={})
      options.merge(ROW_OPTIONS)
    end
  end
end