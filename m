Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1B7322216
	for <lists+kvm-ppc@lfdr.de>; Mon, 22 Feb 2021 23:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhBVWXD (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Feb 2021 17:23:03 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57166 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229518AbhBVWXC (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Feb 2021 17:23:02 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11MMKBQv110915;
        Mon, 22 Feb 2021 17:22:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=f9dR039S9Dz2hqj6nD9JrKg9RAbG636fsNRKd6NvE7Y=;
 b=O9YbKP1FEbqZuXD57NV3Do74bDFThsjtKkDPIz8g0m0FmIAvUvg+s0gYH/uua6AjLc8u
 pYaP2r9IoqK4E9kS7+2+mxVedIiSsw1njT3/VOri/sPwYkNGeg2MRYjZ7ORWDiTBLM+m
 GhKPiB3imkfY6OOOUR3SC98SNlAR4INnZ5wcxVsB7L2OxVLR1LjcF4eVKAevRL3KxAvc
 symYB3jJcs6S/jRlF8Dv5gxecZu0mO/Y7Yu2VmPXC0PQ+LsE0fCuDtMtAuwkn1OUhIm/
 571QZG3ju+8GgfvGoE0ugLuUXlDrOK0ktLifbIfQhJKrlOJMTUhGAGMHuNYY3SMiS0sb gA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36vkg03vs0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 17:22:16 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11MMMGw3114853;
        Mon, 22 Feb 2021 17:22:16 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36vkg03vrx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 17:22:16 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11MMGmEa012583;
        Mon, 22 Feb 2021 22:22:15 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02dal.us.ibm.com with ESMTP id 36tt29prmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 22:22:15 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11MMMEXk32506346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Feb 2021 22:22:15 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4FC4AC059;
        Mon, 22 Feb 2021 22:22:14 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A507AC05E;
        Mon, 22 Feb 2021 22:22:14 +0000 (GMT)
Received: from localhost (unknown [9.160.141.72])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTPS;
        Mon, 22 Feb 2021 22:22:13 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 01/13] powerpc/64s: Remove KVM handler support from
 CBE_RAS interrupts
In-Reply-To: <20210219063542.1425130-2-npiggin@gmail.com>
References: <20210219063542.1425130-1-npiggin@gmail.com>
 <20210219063542.1425130-2-npiggin@gmail.com>
Date:   Mon, 22 Feb 2021 19:22:12 -0300
Message-ID: <87mtvvyc8b.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-22_07:2021-02-22,2021-02-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102220190
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

> Cell does not support KVM.
>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>

> ---
>  arch/powerpc/kernel/exceptions-64s.S | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
> index 39cbea495154..5d0ad3b38e90 100644
> --- a/arch/powerpc/kernel/exceptions-64s.S
> +++ b/arch/powerpc/kernel/exceptions-64s.S
> @@ -2574,8 +2574,6 @@ EXC_VIRT_NONE(0x5100, 0x100)
>  INT_DEFINE_BEGIN(cbe_system_error)
>  	IVEC=0x1200
>  	IHSRR=1
> -	IKVM_SKIP=1
> -	IKVM_REAL=1
>  INT_DEFINE_END(cbe_system_error)
>
>  EXC_REAL_BEGIN(cbe_system_error, 0x1200, 0x100)
> @@ -2745,8 +2743,6 @@ EXC_COMMON_BEGIN(denorm_exception_common)
>  INT_DEFINE_BEGIN(cbe_maintenance)
>  	IVEC=0x1600
>  	IHSRR=1
> -	IKVM_SKIP=1
> -	IKVM_REAL=1
>  INT_DEFINE_END(cbe_maintenance)
>
>  EXC_REAL_BEGIN(cbe_maintenance, 0x1600, 0x100)
> @@ -2798,8 +2794,6 @@ EXC_COMMON_BEGIN(altivec_assist_common)
>  INT_DEFINE_BEGIN(cbe_thermal)
>  	IVEC=0x1800
>  	IHSRR=1
> -	IKVM_SKIP=1
> -	IKVM_REAL=1
>  INT_DEFINE_END(cbe_thermal)
>
>  EXC_REAL_BEGIN(cbe_thermal, 0x1800, 0x100)
