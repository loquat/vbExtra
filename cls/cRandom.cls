VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRandom"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Enum EErrorRandom
    eeBaseRandom = 13580    ' Random
    eeBaseIllegalRange      ' Random: Range can't be greater than 2147483645
End Enum

' For Random algorithm
Private iLast As Long
Private Const a As Long = 48271
Private Const M As Long = 2147483647
Private Const Max As Long = 2147483645
Private Const Q As Long = (M / a)
Private Const R As Long = (M Mod a)
Private Const rT As Single = 1# / Max

' VB6 verions includes fixes suggested by Lynn Torkelson

Private Sub Class_Initialize()
    Seed 0
End Sub

' Pedigree for the Random and Seed algorithms

'****************************************************************************
'* PMMMLCG - Prime Modulus M Multiplicative Linear Congruential Generator   *
'*  Modified version of the random number generator proposed by             *
'*  Park & Miller in "Random Number Generators: Good Ones Are Hard to Find" *
'*  CACM October 1988, Vol 31, No. 10                                       *
'*   - Modifications proposed by Park to provide better statistical         *
'*     properties (i.e. more "random" - less correlation between sets of    *
'*     generated numbers                                                    *
'*   - generator is of the form                                             *
'*         x = ( x * A) % M                                                 *
'*   - Choice of A & M can radically modify the properties of the generator *
'*     the current values were chosen after followup work to the original   *
'*     paper mentioned above.                                               *
'*   - The generator has a period of 2^31 - 1 with numbers generated in the *
'*     range of 0 < x < M                                                   *
'*   - The generator can run on any machine with a 32-bit integer, without  *
'*     overflow.                                                            *
'*   - This generator is currently running on Sun 3/50, Sparc, IBM PC/XT,   *
'*     IBM RS/6000 just to name a few...                                    *
'****************************************************************************
'*    John Burton                                                           *
'*    g & A Technical Software, Inc                                         *
'*    28 Research Drive                                                     *
'*    Hampton, Va. 23666                                                    *
'*                                                                          *
'*    jcburt@cs.wm.edu                                                      *
'*    jcburt@gatsibm.larc.nasa.gov                                          *
'*    burton@asdsun.larc.nasa.gov                                           *
'****************************************************************************

'*  Random() - return next random number
'*
'*      The Random() subroutine returns a pseudo-random long value in
'*      the range Min <= x < Max
Public Function Random(Optional ByVal iMin As Long = 0, _
                Optional ByVal iMax As Long = Max) As Long
    Dim iLo As Long, iHi As Long, iT As Long
    If iLast = 0 Then Class_Initialize
    ' Can't have range larger than 2147483645
    If Abs(iMax - iMin) > Max Then ErrRaise eeBaseIllegalRange
    iHi = iLast / Q
    iLo = iLast Mod Q
  
    iT = (a * iLo) - (R * iHi)
    If iT >= 0 Then
        iLast = iT
    Else
        iLast = iT + M
    End If
    ' Range is 1-2147483646; adjust range to 0-2147483645
    Random = iLast - 1
    If iMin <> 0 Or iMax <> Max Then
        If iMin < iMax Then
            Random = iMin + ((iLast - 1) Mod (iMax - iMin + 1))
        Else
            Random = iMax + ((iLast - 1) Mod (iMin - iMax + 1))
        End If
    End If

End Function

'*  RandomReal() - return next random number
'*
'*      The RandomReal() function returns a pseudo-random floating point value
'*      in the range 0.0 <= x < 1.0.
Public Function RandomReal() As Single
    RandomReal = CSng(Random * rT)
End Function

'*  Seed - Set first random number in a sequence based on a seed
'*
'*      The Seed procedure sets the starting point for generating a series
'*      of pseudo-random values. To re-initialize the generator with the same
'*      sequennce, use -1 as the seed argument. Use any positive seed value sets the generator to a random
'*      starting point.
'*
'*      Calling Random or RandomReal before any call to Seed will generate a
'*      sequence based on the system timer.

Public Sub Seed(Optional ByVal iSeed As Long = -1)

    Static iLastSeed As Long
    Select Case iSeed
    Case -1
        ' -1 reserved for reinitializing last sequence
        If iLastSeed Then iLast = iLastSeed Else iLast = Abs(Timer) ' timeGetTime
        Exit Sub
    Case 0
        ' Algorithm won't handle 0 seed, so use it to represent system timer
        iLast = Abs(Timer) ' timeGetTime
    Case Else
        iLast = Abs(iSeed)
    End Select
    iLastSeed = iLast
    
End Sub

'  Return current seed (save to reproduce a sequence later)
Public Function GetSeed() As Long
    GetSeed = iLast
End Function

Private Sub ErrRaise(e As Long)
    Dim sText As String, sSource As String
    If e > 1000 Then
        sSource = App.EXEName & ".Random"
        Select Case e
        Case eeBaseRandom
            'BugAssert True
        Case eeBaseIllegalRange
            sText = "Random: Range can't be greater than 2147483645"
       ' Case ee...
       '     Add additional errors
        End Select
        Err.Raise e Or vbObjectError, sSource, sText
    Else
        ' Raise standard Visual Basic error
        sSource = App.EXEName & ".VBError"
        Err.Raise e, sSource
    End If
End Sub




