Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 597A3633E0
	for <lists+kvm-ppc@lfdr.de>; Tue,  9 Jul 2019 12:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbfGIKFM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 9 Jul 2019 06:05:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57718 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725989AbfGIKFL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 9 Jul 2019 06:05:11 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x69A2tqL080941
        for <kvm-ppc@vger.kernel.org>; Tue, 9 Jul 2019 06:05:10 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tmptgn3cq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Tue, 09 Jul 2019 06:05:09 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Tue, 9 Jul 2019 11:05:08 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 9 Jul 2019 11:05:06 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x69A54O233292518
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Jul 2019 10:05:05 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C955642049;
        Tue,  9 Jul 2019 10:05:04 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10D964203F;
        Tue,  9 Jul 2019 10:05:03 +0000 (GMT)
Received: from in.ibm.com (unknown [9.85.81.51])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  9 Jul 2019 10:05:02 +0000 (GMT)
Date:   Tue, 9 Jul 2019 15:34:57 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, sukadev@linux.vnet.ibm.com,
        cclaudio@linux.ibm.com
Subject: Re: [PATCH v4 3/6] kvmppc: H_SVM_INIT_START and H_SVM_INIT_DONE
 hcalls
Reply-To: bharata@linux.ibm.com
References: <20190528064933.23119-1-bharata@linux.ibm.com>
 <20190528064933.23119-4-bharata@linux.ibm.com>
 <20190617053756.z4disbs5vncxneqj@oak.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617053756.z4disbs5vncxneqj@oak.ozlabs.ibm.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-TM-AS-GCONF: 00
x-cbid: 19070910-0016-0000-0000-000002909318
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070910-0017-0000-0000-000032EE4565
Message-Id: <20190709100457.GB27933@in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-09_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907090122
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Jun 17, 2019 at 03:37:56PM +1000, Paul Mackerras wrote:
> On Tue, May 28, 2019 at 12:19:30PM +0530, Bharata B Rao wrote:
> > H_SVM_INIT_START: Initiate securing a VM
> > H_SVM_INIT_DONE: Conclude securing a VM
> > 
> > As part of H_SVM_INIT_START register all existing memslots with the UV.
> > H_SVM_INIT_DONE call by UV informs HV that transition of the guest
> > to secure mode is complete.
> 
> It is worth mentioning here that setting any of the flag bits in
> kvm->arch.secure_guest will cause the assembly code that enters the
> guest to call the UV_RETURN ucall instead of trying to enter the guest
> directly.  That's not necessarily obvious to the reader as this patch
> doesn't touch that assembly code.

Documented this in the commit message.

> 
> Apart from that this patch looks fine.
> 
> > Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
> 
> Acked-by: Paul Mackerras <paulus@ozlabs.org>

Thanks,
Bharata.

