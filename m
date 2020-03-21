Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64E9018DC90
	for <lists+kvm-ppc@lfdr.de>; Sat, 21 Mar 2020 01:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbgCUAk5 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 20 Mar 2020 20:40:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35698 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726773AbgCUAk5 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 20 Mar 2020 20:40:57 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02L0a9nQ134112
        for <kvm-ppc@vger.kernel.org>; Fri, 20 Mar 2020 20:40:55 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yu7dck7re-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Fri, 20 Mar 2020 20:40:55 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <linuxram@us.ibm.com>;
        Sat, 21 Mar 2020 00:40:54 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 21 Mar 2020 00:40:50 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02L0emlp43516332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 Mar 2020 00:40:48 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2D794203F;
        Sat, 21 Mar 2020 00:40:48 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6136C42042;
        Sat, 21 Mar 2020 00:40:47 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.85.223.94])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sat, 21 Mar 2020 00:40:47 +0000 (GMT)
Date:   Fri, 20 Mar 2020 17:40:44 -0700
From:   Ram Pai <linuxram@us.ibm.com>
To:     Laurent Dufour <ldufour@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, Bharata B Rao <bharata@linux.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20200320102643.15516-1-ldufour@linux.ibm.com>
 <20200320102643.15516-2-ldufour@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320102643.15516-2-ldufour@linux.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 20032100-0012-0000-0000-00000394C5B1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032100-0013-0000-0000-000021D1B0B5
Message-Id: <20200321004044.GA5243@oc0525413822.ibm.com>
Subject: Re:  [PATCH 1/2] KVM: PPC: Book3S HV: check caller of H_SVM_* Hcalls
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-20_08:2020-03-20,2020-03-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 mlxscore=0 suspectscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003200094
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Mar 20, 2020 at 11:26:42AM +0100, Laurent Dufour wrote:
> The Hcall named H_SVM_* are reserved to the Ultravisor. However, nothing
> prevent a malicious VM or SVM to call them. This could lead to weird result
> and should be filtered out.
> 
> Checking the Secure bit of the calling MSR ensure that the call is coming
> from either the Ultravisor or a SVM. But any system call made from a SVM
> are going through the Ultravisor, and the Ultravisor should filter out
> these malicious call. This way, only the Ultravisor is able to make such a
> Hcall.
> 
> Cc: Bharata B Rao <bharata@linux.ibm.com>
> Cc: Paul Mackerras <paulus@ozlabs.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>

Reviewed-by: Ram Pai <linuxram@us.ibnm.com>

> ---
>  arch/powerpc/kvm/book3s_hv.c | 32 +++++++++++++++++++++-----------
>  1 file changed, 21 insertions(+), 11 deletions(-)
> 

