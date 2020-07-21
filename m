Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15793228B42
	for <lists+kvm-ppc@lfdr.de>; Tue, 21 Jul 2020 23:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730488AbgGUV2v (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 21 Jul 2020 17:28:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31816 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726658AbgGUV2u (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 21 Jul 2020 17:28:50 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06LL2wsa152507;
        Tue, 21 Jul 2020 17:28:24 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32e1vv3xnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 17:28:24 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06LLA6KI024505;
        Tue, 21 Jul 2020 21:28:22 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 32brq826kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 21:28:22 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06LLSJ7230146928
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jul 2020 21:28:19 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5257E11C050;
        Tue, 21 Jul 2020 21:28:19 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA3AB11C052;
        Tue, 21 Jul 2020 21:28:16 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.163.39.1])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 21 Jul 2020 21:28:16 +0000 (GMT)
Date:   Tue, 21 Jul 2020 14:28:13 -0700
From:   Ram Pai <linuxram@us.ibm.com>
To:     Laurent Dufour <ldufour@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org,
        sukadev@linux.ibm.com, bauerman@linux.ibm.com,
        bharata@linux.ibm.com, Paul Mackerras <paulus@ozlabs.org>
Subject: Re: [PATCH v2 1/2] KVM: PPC: Book3S HV: move kvmppc_svm_page_out up
Message-ID: <20200721212813.GF7339@oc0525413822.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20200721104202.15727-1-ldufour@linux.ibm.com>
 <20200721104202.15727-2-ldufour@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721104202.15727-2-ldufour@linux.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-21_15:2020-07-21,2020-07-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 spamscore=0 bulkscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=871 malwarescore=0 clxscore=1011
 adultscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007210135
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Jul 21, 2020 at 12:42:01PM +0200, Laurent Dufour wrote:
> kvmppc_svm_page_out() will need to be called by kvmppc_uvmem_drop_pages()
> so move it upper in this file.
> 
> Furthermore it will be interesting to call this function when already
> holding the kvm->arch.uvmem_lock, so prefix the original function with __
> and remove the locking in it, and introduce a wrapper which call that
> function with the lock held.
> 
> There is no functional change.

Reviewed-by: Ram Pai <linuxram@us.ibm.com>

> 
> Cc: Ram Pai <linuxram@us.ibm.com>
> Cc: Bharata B Rao <bharata@linux.ibm.com>
> Cc: Paul Mackerras <paulus@ozlabs.org>
> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
> ---

RP
