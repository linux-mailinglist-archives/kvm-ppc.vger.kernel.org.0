Return-Path: <kvm-ppc+bounces-120-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C3178CBD7C
	for <lists+kvm-ppc@lfdr.de>; Wed, 22 May 2024 11:05:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F9071C20BD1
	for <lists+kvm-ppc@lfdr.de>; Wed, 22 May 2024 09:05:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7E7E18EB1;
	Wed, 22 May 2024 09:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XPQMWG4l"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C627FBBD
	for <kvm-ppc@vger.kernel.org>; Wed, 22 May 2024 09:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716368730; cv=none; b=ih7Lt8OXsERTIV/lwYLOcA+2IMmbvAxCnH33Yr6dr1FVWxsJcnDUYCwqSSAdq5pQmN50LREUUKfQsEJqKJ+SRzBemTNwnj6FOwSLUTGlImE5D0K72DKHaHtejCAr9LY6QpeWeFBqh9Y58Wq576G4he2O8ijWoNWao3VfjRyFCbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716368730; c=relaxed/simple;
	bh=FkJg5mAol3KqTlwuHnfxJOi/E2XOrkEPuWgq5zWVBfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QUsuCDp4n6wk5XNxcvljfr2AB47naxIgrcNqCJGZUBSIoDlVLe/yioe2JQDh6o/JWKsdzlMTbHZDcHWm5hYd+2DxnNqWpZLc5tjcusLOjePomcb4kqlAYPxPjtAQZvYrw2o7GykXLeGVwdj+CyihnOTliatECx67j4jsl+ks5dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XPQMWG4l; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44M8cIh9032228;
	Wed, 22 May 2024 09:05:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=U88s7wD4SpoLbzq8E43jKOImGxepySFrsAmmhlHO750=;
 b=XPQMWG4lf7DVXlnYxnvD9iqpl4IVbgmCG4FSD7COUlMKEFbq2P3/Z3oV1EW9uKcntb5V
 tQ54un9KZfd+sGF5U/86LE9IYp6W5NHSIlzx2aijclKWkA4e9wRbgvhJ9rMZ86XwXiIi
 VxYvtl0Sr4dLy78hlJhU0TglTK+7FG54atcZCzzxHeSDgdDPFatRJbgi+Ap8I0sZtZ1W
 KtDpYzxXdA36WQ3uQp8fRO3K5xTWYrxt0DOr3BDVyVBDpyYCvbQMZ3je+yhwJHfPN/4M
 niXO+Tmniie+xBPkAQr1PfNlJQihktswhfmTAYxK4ZA2hmdATooWgP3cV+jzLkzS54G5 GA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y9dc3r29y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 09:05:12 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44M95CZ2010995;
	Wed, 22 May 2024 09:05:12 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y9dc3r29h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 09:05:12 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44M8AZrC007817;
	Wed, 22 May 2024 09:05:04 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3y78vm2nuq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 09:05:04 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44M950Yu52167074
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 May 2024 09:05:03 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B020820043;
	Wed, 22 May 2024 09:05:00 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E3FAC20040;
	Wed, 22 May 2024 09:04:57 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.171.70.34])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 22 May 2024 09:04:57 +0000 (GMT)
Date: Wed, 22 May 2024 14:34:54 +0530
From: Kautuk Consul <kconsul@linux.ibm.com>
To: Kautuk Consul <kconsul@linux.vnet.ibm.com>
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
        Thomas Huth <thuth@redhat.com>, aik@ozlabs.ru, groug@kaod.org,
        slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v2] slof/engine.in: refine +COMP and -COMP by not using
 COMPILE
Message-ID: <Zk21NmxuSUlWVhgs@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240202051548.877087-1-kconsul@linux.vnet.ibm.com>
 <Zcnkzks7D0eHVYZQ@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <20240223205723.GO19790@gate.crashing.org>
 <ZdwV/1bmGSGi8MnZ@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <ZelfudAMYcXGCgBN@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <ZffNVdhtAzY32Jsx@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZffNVdhtAzY32Jsx@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SqJi_Hw7GhepUzdOUT3qXcYlcwCsDVgP
X-Proofpoint-GUID: xjSB4rp76L_54tX-rmd25sztDe6HPO7I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-22_03,2024-05-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 spamscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=547
 priorityscore=1501 impostorscore=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405220063

Hi Segher/Alexey/Thomas,

> > > If you want to improve engine.in, get rid of it completely?  Make the
> > > whol thing cross-compile perhaps.  Everything from source code.  The
> > > engine.in thing is essentially an already compiled thing (but not
> > > relocated yet, not fixed to some address), which is still in mostly
> > > obvious 1-1 correspondence to it source code, which can be easily
> > > "uncompiled" as well.  Like:
> > 
> > :-). Getting rid of it completely and making the whole thing
> > cross-compile would require more time that I'm not so sure that I or
> > even my manager would be able to spare in our project.
> > 
> > > 
> > > col(+COMP STATE @ 1 STATE +! 0BRANCH(1) EXIT HERE THERE ! COMP-BUFFER DOTO HERE COMPILE DOCOL)
> > > col(-COMP -1 STATE +! STATE @ 0BRANCH(1) EXIT COMPILE EXIT THERE @ DOTO HERE COMP-BUFFER EXECUTE)
> > > 
> > > : +comp  ( -- )
> > >   state @  1 state +!  IF exit THEN
> > >   here there !
> > >   comp-buffer to here
> > >   compile docol ;
> > > : -comp ( -- )
> > >   -1 state +!
> > >   state @ IF exit THEN
> > >   compile exit
> > >   there @ to here
> > >   comp-buffer execute ;
> > > 
> > > "['] semicolon compile," is not something a user would ever write.  A
> > > user would write "compile exit".  It is standard Forth, it works
> > > anywhere.  It is much more idiomatic..
> > 
> > Okay, I can accept the fact that maybe we should use EXIT instead of
> > SEMICOLON. But at least can we remove the invocation of the "COMPILE"
> > keyword in +COMP and -COMP ? The rest of the compiler in slof/engine.in
> > uses the standard "DOTICK <word> COMPILE," format so why cannot we use
> > this for -COMP as well as +COMP ?
> > 
Do you all agree with the above reasoning as well as the fact that I think
we would all here (in the KVM team) appreciate even this small
improvement in performance ?
Can I send a v3 patch with the "DOTICK EXIT COMPILE," "DOTICK DOCOL COMPILE," changes ?

Or should I just abandon this patch ? My point is that when we aren't
doing anything unorthodox in/with the slof/engine.in code then why not
go in for a useful optimization in SLOF as this is part of the KVM Over
PowerVM product ?

