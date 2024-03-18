Return-Path: <kvm-ppc+bounces-69-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D5A8987E2E8
	for <lists+kvm-ppc@lfdr.de>; Mon, 18 Mar 2024 06:13:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86FB1281EA8
	for <lists+kvm-ppc@lfdr.de>; Mon, 18 Mar 2024 05:13:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6420C208B6;
	Mon, 18 Mar 2024 05:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LY+/d94T"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BC43214
	for <kvm-ppc@vger.kernel.org>; Mon, 18 Mar 2024 05:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710738807; cv=none; b=PNr1tprClFMiArhN41fcQk8eS6f4VDZN8sLQWEmhFTeeixZ863G0Mc9fyDuGNbCZaJdf0HUZnSgSgrte2ESFQIhFlasp2EFpKwwIwYozXmPgtpO8DYC+KSuAzK+HHeQfemfsLmv/pMsFJCzokGMfJByceyQKSPs6dmLjf7uTz5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710738807; c=relaxed/simple;
	bh=wFPE6l1ybi0CPTDs/Ly1qb9a3DslSMEh/e7zaxoYYaI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KvMGiq6dqhe3rKQfViR8etA5DZifA7zUjz4lOpqwx5BFxNTHIqCXMuqocyTAb94ndwViDvepEdxMZ4ZEQLOhpttUZEQWyr0ttEPO05YgHL0+mz2o8MAEHT9tuYeb4xQKoFHyIH5sZX8UTTRgKs7fxK1/IFSILF2ZSf96RAd+Wo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LY+/d94T; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42I3Sx4H012143;
	Mon, 18 Mar 2024 05:13:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=u6gXO+OCJSrW5ZDl17jJreyfYayRwtkfTIZfl6TJEBw=;
 b=LY+/d94TRiP5IYI6+H/7bHbw33GzYlLaT2PDSwRo6awDiNSF2ikCkCquGUznC5xOFT2T
 ecziz39G6MJ7REeG41cCu53FbCoUgUZlqLvlYXoX9w10y3HfAng+l6DzjAWVoEZm6Ndp
 hU+skNXyEcD58XxEOiPywte5M29x6D0CVM9ar0Mpu65EuSstbc+Mbit+ba5srMuh8yMu
 3D7yuD9qC/4NJbeID9yKYyfkWsatGa5WAWeayLV4CYk+AjoJe50imuP5WuDSTaGihz4+
 ddmCK4A9G600JDtLSmoB6Irnx76S8dKNL64b78VhnPhvTQcG/KhCwNYDVaZWkbfkpIxW 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ww9s05p6v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Mar 2024 05:13:05 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42I5D5Ak019368;
	Mon, 18 Mar 2024 05:13:05 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ww9s05p6s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Mar 2024 05:13:05 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42I3CEPK011615;
	Mon, 18 Mar 2024 05:13:04 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3wwq8kpkfs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Mar 2024 05:13:04 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42I5D0W026935808
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Mar 2024 05:13:02 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 914D820049;
	Mon, 18 Mar 2024 05:13:00 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5E6C720040;
	Mon, 18 Mar 2024 05:12:59 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.109.216.99])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 18 Mar 2024 05:12:59 +0000 (GMT)
Date: Mon, 18 Mar 2024 10:42:53 +0530
From: Kautuk Consul <kconsul@linux.vnet.ibm.com>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Thomas Huth <thuth@redhat.com>, aik@ozlabs.ru, groug@kaod.org,
        slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v2] slof/engine.in: refine +COMP and -COMP by not using
 COMPILE
Message-ID: <ZffNVdhtAzY32Jsx@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240202051548.877087-1-kconsul@linux.vnet.ibm.com>
 <Zcnkzks7D0eHVYZQ@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <20240223205723.GO19790@gate.crashing.org>
 <ZdwV/1bmGSGi8MnZ@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <ZelfudAMYcXGCgBN@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZelfudAMYcXGCgBN@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JKTZzAFkelqHP6s_NQ5Svk98SEeNaKza
X-Proofpoint-GUID: ZoB7ZB33WvRcXHiregIhAC6tYJpz5Gby
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-17_12,2024-03-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 adultscore=0 mlxscore=0 mlxlogscore=537 suspectscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403140000 definitions=main-2403180037

Hi Segher,
> 
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

