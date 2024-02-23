Return-Path: <kvm-ppc+bounces-55-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 02A95860A85
	for <lists+kvm-ppc@lfdr.de>; Fri, 23 Feb 2024 06:59:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3426E1C23480
	for <lists+kvm-ppc@lfdr.de>; Fri, 23 Feb 2024 05:59:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAED7125A7;
	Fri, 23 Feb 2024 05:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bSzQ2QwG"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FB611C84
	for <kvm-ppc@vger.kernel.org>; Fri, 23 Feb 2024 05:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708667984; cv=none; b=ld8Z7TgWhAH03AoIOq/761NIk2KxpAofPDlmQOaPZ5JbJE+CCeKi7YGHPoxRRISov/V3bzvRWOImMruBo0tdrlz9fJ0DgT/wEwQPRW95HUPSh37tAmws6xWH8efLXS4XpYY4SjFKPk91kJ9NgbuT+AbPNEfl6aZ0PsO/XdecQSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708667984; c=relaxed/simple;
	bh=GTA0ORH9A4HpzxfpFXeaR2g+XaYQGpjP4MKUzLfrUBE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IUb+TedDN3sMI1OP5W+IErzzkc0tDLtM3ScsVlFeQHCxOSKNkgpGwVa5FJDHOEnBaK4X7OStlQNv2D+m3dMAEC/0w+KkHiBxOvBf44XqGiVDjqv/KT2c40GW1Y6FPOOA1dZh2S0nwy+YUvj+QeZ+N0t3DlRm5qOPD2CK3DEYypQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bSzQ2QwG; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41N5r6sk028322;
	Fri, 23 Feb 2024 05:59:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=xn/dLzZ4pj66zE0jRIOpkq8QSS8mN2yEJu7t7x0Twkg=;
 b=bSzQ2QwGJfPRdpKzEF74DD0X4IJU59aNNtblTt9NP5JWLkDXnhhw81gONu9FTihP9Dgf
 1XyV9KFzDLRzndFR4AezoUoUBjreFU6zxwgEJtg3eZYGjmeNbzUcYSXIGB/HRKAeAqh5
 TRbz23jOZf4xDX2JIxs/ERs+ElYsZ/kkUnY2rRKg1K3hTTWrQISLKhEIdUQZKCb7JWfg
 JcSdtPebBW3ocXjdTS9vQlmuKEntUuTiB0GDO9Nn/2qtvPpXx/7A1WVDVGGgclIEfoT6
 /WTa15QIM8GVXFjFHNHfEjKAEkT2Cz3iQLXp9CmJmiNbwbDpFrf7PDB+QbGbPEVZquQB 2A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wenkp07dj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Feb 2024 05:59:33 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41N5r6eQ028330;
	Fri, 23 Feb 2024 05:59:33 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wenkp07de-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Feb 2024 05:59:32 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 41N3g9D2014347;
	Fri, 23 Feb 2024 05:59:32 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3wb9u32v1q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Feb 2024 05:59:32 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 41N5xSOD66388420
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Feb 2024 05:59:30 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B9EF20043;
	Fri, 23 Feb 2024 05:59:28 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5FA9B20040;
	Fri, 23 Feb 2024 05:59:26 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.171.30.246])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 23 Feb 2024 05:59:26 +0000 (GMT)
Date: Fri, 23 Feb 2024 11:29:23 +0530
From: Kautuk Consul <kconsul@linux.vnet.ibm.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Segher Boessenkool <segher@kernel.crashing.org>, aik@ozlabs.ru,
        groug@kaod.org, slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v2] slof/engine.in: refine +COMP and -COMP by not using
 COMPILE
Message-ID: <Zdg0O/67vQIip7hN@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240202051548.877087-1-kconsul@linux.vnet.ibm.com>
 <Zdb56vX+ZpApmsqK@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <278a0e1e-b257-47ef-a908-801b9a223080@redhat.com>
 <Zdc0CeOTVeob77Lj@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zdc0CeOTVeob77Lj@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Mwym4Vtkpg-_VtHboHWUU1Zh8v83qiqG
X-Proofpoint-ORIG-GUID: UQBW0FLFa6PvONG8g4AjFT_ClQZp-H-5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-22_15,2024-02-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 spamscore=0 priorityscore=1501 mlxlogscore=782 suspectscore=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402230040

Just to clarify one last point:

On 2024-02-22 17:16:33, Kautuk Consul wrote:
> Hi Thomas,
> 
> > 
> >  Hi Kautuk,
> > 
> > could you maybe do some performance checks to see whether this make a
> > difference (e.g. by running the command in a tight loop many times)?
Running a single loop many times will not expose much because that loop
(which is NOT within a Forth colon subroutine) will compile only once.
In my performance benchmarking with tb@ I have put 45 IF-THEN and
IF2-THEN2 control statements that will each compile once and reveal the
difference in compilation speeds.

> > You can use "tb@" to get the current value of the timebase counter, so
> > reading that before and after the loop should provide you with a way of
> > measuring the required time.
> > 
> >  Thomas
> > 

