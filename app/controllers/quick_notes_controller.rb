class QuickNotesController < ApplicationController
  def new
    @quick_note = QuickNote.new
  end

  def create
    @quick_note = current_user.quick_notes.build(quick_note_params)
    if @quick_note.save
      flash[:success] = "Quick note created"
      redirect_to root_path
    else
      render 'new'
    end
  end

  private
    def quick_note_params
        params.require(:quick_note).permit(:name, :category, :content)
    end
end
