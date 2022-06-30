library(lubridate)
library(ggplot2)

Pdf=read.csv("MHWParams_Apr2021.csv",row.names = 1)
Qdf = data.frame(t(Pdf))
colnames(Qdf) = rownames(Pdf)
NS=500  #number of simulations
NY=120 #number of years
NR=NY*365 #record length in days
X=matrix(0,nrow=NR,ncol=NS)
Qdf$slope=exp(-1/Qdf$tau)

#n=1  #OISST
#n=3 #CombWT
n=5 #WACH
X=matrix(0,nrow=NR,ncol=NS)

for (j in 1:NS){
  Er = rnorm(NR,mean=0,sd=Qdf$sig_e[n])
  for (i in 2:NR) {X[i,j] = Qdf$slope[n]*X[i-1,j] + Er[i]}
}

Sdf=read.csv("AnnSeasClim_Apr2021.csv")
Sdf$Date=as.Date(Sdf$doy, origin = "2019-01-01")
Tdf=read.csv("AnnThreshClim_Apr2021.csv")
Tdf$Date=as.Date(Tdf$doy, origin = "2019-01-01")

decY=1:(NY*365)/365+1982
YMD=date_decimal(decY); YMD=as.Date(YMD); M=month(YMD);
YV=floor(decY); YV[length(YV)]=YV[(length(YV)-1)]
Xtrnd=Qdf$Intcpt[n]+Qdf$Trend[n]*decY
Xt=X+Xtrnd  #add trend from SST data
Xst=Xt+rep(Sdf$OISST,NY)   #add seasonal cycle to trend
Xs=X+rep(Sdf$OISST,NY)
XthV=rep(Tdf$OISST,NY)

Xexp=matrix(0,nrow=NY,ncol=NS); Xa28=Xexp; Xint=Xexp
nev=rep(0,NS); nmhw=rep(0,NS); inten=rep(0,NS)
frachi = rep(0,NS)
for (j in 1:NS) {
  Xhi=rep(0,NR); N28=Xhi
  Xhi[(Xst[,j]-XthV)>0]=1
  frachi[j]=sum(Xhi)/NR
  dX=diff(Xhi)
  nd = which(dX==1)
  np = which(dX==-1)
  if (np[1]<nd[1]) np=np[-1]
  if (length(np) != length(nd)) nd=nd[-length(nd)]
  durXHi=np-nd
  n5=which(durXHi>=5)
  nev[j]=length(np); nmhw[j]=length(n5)
  inten=rep(0,length(n5))
  for (k in 1:length(n5)){
    inten[k]=max(Xt[nd[n5[k]]:np[n5[k]],j])
  }
  Dint=aggregate(inten ~ YV[nd[n5]], FUN=max, na.action=na.pass)
  colnames(Dint)=c("Y","intMHW")
  Sint=rep(0,NY)
  Sint[Dint$Y-YV[1]+1]=Dint$intMHW
  Xint[,j]=Sint
  
  Dexp=aggregate(durXHi[n5] ~ YV[nd[n5]], FUN=sum, na.action=na.pass)
  colnames(Dexp)=c("Y","expMHW")
  Sexp=rep(0,NY)
  Sexp[Dexp$Y-YV[1]+1]=Dexp$expMHW
  Xexp[,j]=Sexp
  
  N28[Xst[,j]>=28]=1
  a28=aggregate(N28 ~ YV, FUN=sum, na.action=na.pass)    
  colnames(a28)=c("Y","abv28")
  Sa28=rep(0,NY)
  Sa28[a28$Y-YV[1]+1]=a28$abv28
  Xa28[,j]=Sa28
}

Y=1982:(1982+NY-1)
EM=rowMeans(Xexp)
Esd=apply(Xexp,1,sd)
IM=rowMeans(Xint)
Isd=apply(Xint,1,sd)
A28=rowMeans(Xa28)
Asd=apply(Xa28,1,sd)

qplot(Y,EM)+geom_ribbon(aes(x=Y, ymin=EM-Esd, ymax=EM+Esd), fill="light blue", alpha=0.3)
qplot(Y,IM)+geom_ribbon(aes(x=Y, ymin=IM-Isd, ymax=IM+Isd), fill="light blue", alpha=0.3)
qplot(Y,A28)+geom_ribbon(aes(x=Y, ymin=A28-Asd, ymax=A28+Asd), fill="light blue", alpha=0.3)

if (n==1) write.csv(cbind(Y,EM,Esd,IM,Isd,A28,Asd),"SimOI28_nov2021b.csv")
if (n==3) write.csv(cbind(Y,EM,Esd,IM,Isd,A28,Asd),"SimCV28_nov2021b.csv")
if (n==5) write.csv(cbind(Y,EM,Esd,IM,Isd,A28,Asd),"SimWA28_nov2021b.csv")

