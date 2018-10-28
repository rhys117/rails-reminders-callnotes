class QuickNotesController < ApplicationController
  before_action :logged_in_user

  def new
    @quick_note = QuickNote.new
  end

  def index
    @quick_notes = current_user.quick_notes.all.paginate(page: params[:page])
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

  def edit
    @quick_note = current_user.quick_notes.find(params[:id])
  end

  def update
    @quick_note = current_user.quick_notes.find(params[:id]).update_attributes(quick_note_params)
    if @quick_note
      flash[:success] = "Quick copy updated"
      redirect_to(edit_quick_note_path)
    else
      @quick_note = current_user.quick_notes.build(quick_note_params)
      @quick_note.save
      flash[:danger] = @quick_note.errors.full_messages.to_sentence
      redirect_to(edit_quick_note_path(params[:id]))
    end
  end

  def destroy
    current_user.quick_notes.find(params[:id]).destroy
    flash[:success] = "Quick note deleted"
    redirect_to quick_notes_url
  end

  private
    def quick_note_params
        params.require(:quick_note).permit(:name, :category, :content)
    end
end
