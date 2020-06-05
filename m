Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871101EFB8E
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Jun 2020 16:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgFEOjI (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Jun 2020 10:39:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12772 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726553AbgFEOjI (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Jun 2020 10:39:08 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 055EW5dH073750;
        Fri, 5 Jun 2020 10:38:53 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31fk7ds7ws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 10:38:53 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 055EUuxZ003634;
        Fri, 5 Jun 2020 14:38:50 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 31bf484duy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 14:38:50 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 055EckcQ45744332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Jun 2020 14:38:47 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0D1B42045;
        Fri,  5 Jun 2020 14:38:45 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5B0542047;
        Fri,  5 Jun 2020 14:38:42 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.163.3.67])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  5 Jun 2020 14:38:42 +0000 (GMT)
Date:   Fri, 5 Jun 2020 07:38:39 -0700
From:   Ram Pai <linuxram@us.ibm.com>
To:     Laurent Dufour <ldufour@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        bharata@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, bauerman@linux.ibm.com,
        david@gibson.dropbear.id.au, cclaudio@linux.ibm.com
Subject: Re: [PATCH v1 2/4] KVM: PPC: Book3S HV: track shared GFNs of secure
 VMs
Message-ID: <20200605143839.GB5772@oc0525413822.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1590892071-25549-1-git-send-email-linuxram@us.ibm.com>
 <1590892071-25549-3-git-send-email-linuxram@us.ibm.com>
 <4e1a5f90-984a-129c-d336-98fc90019379@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e1a5f90-984a-129c-d336-98fc90019379@linux.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-05_04:2020-06-04,2020-06-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 priorityscore=1501
 cotscore=-2147483648 phishscore=0 impostorscore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006050107
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

> >diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> >index 803940d..3448459 100644
> >--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
> >+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> >@@ -1100,7 +1100,7 @@ void kvmppc_radix_flush_memslot(struct kvm *kvm,
> >  	unsigned int shift;
> >  	if (kvm->arch.secure_guest & KVMPPC_SECURE_INIT_START)
> >-		kvmppc_uvmem_drop_pages(memslot, kvm, true);
> >+		kvmppc_uvmem_drop_pages(memslot, kvm, true, false);
> 
> Why purge_gfn is false here?
> That call function is called when dropping an hot plugged memslot.

This function does not know, under what context it is called. Since
its job is to just flush the memslot, it cannot assume anything
about purging the pages in the memslot.

.snip..


RP
