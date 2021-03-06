// This is a generated file. Not intended for manual editing.
package org.logtalk.intellij.psi.impl;

import java.util.List;
import org.jetbrains.annotations.*;
import com.intellij.lang.ASTNode;
import com.intellij.psi.PsiElement;
import com.intellij.psi.PsiElementVisitor;
import com.intellij.psi.util.PsiTreeUtil;
import static org.logtalk.intellij.psi.LogtalkTypes.*;
import com.intellij.extapi.psi.ASTWrapperPsiElement;
import org.logtalk.intellij.psi.*;

public class LogtalkMapReferenceImpl extends ASTWrapperPsiElement implements LogtalkMapReference {

  public LogtalkMapReferenceImpl(ASTNode node) {
    super(node);
  }

  public void accept(@NotNull LogtalkVisitor visitor) {
    visitor.visitMapReference(this);
  }

  public void accept(@NotNull PsiElementVisitor visitor) {
    if (visitor instanceof LogtalkVisitor) accept((LogtalkVisitor)visitor);
    else super.accept(visitor);
  }

  @Override
  @Nullable
  public LogtalkAtom getAtom() {
    return findChildByClass(LogtalkAtom.class);
  }

  @Override
  @Nullable
  public LogtalkBracedBlock getBracedBlock() {
    return findChildByClass(LogtalkBracedBlock.class);
  }

  @Override
  @NotNull
  public List<LogtalkVariable> getVariableList() {
    return PsiTreeUtil.getChildrenOfTypeAsList(this, LogtalkVariable.class);
  }

}
