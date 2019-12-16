Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7490B11FD38
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Dec 2019 04:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbfLPD3X (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 15 Dec 2019 22:29:23 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43314 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726528AbfLPD3X (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 15 Dec 2019 22:29:23 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBG3RLLb104734
        for <kvm-ppc@vger.kernel.org>; Sun, 15 Dec 2019 22:29:22 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wvv8vyg2r-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Sun, 15 Dec 2019 22:29:22 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Mon, 16 Dec 2019 03:29:19 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 16 Dec 2019 03:29:16 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBG3TFQl61800468
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Dec 2019 03:29:15 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BB4D42042;
        Mon, 16 Dec 2019 03:29:15 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17ADC42045;
        Mon, 16 Dec 2019 03:29:14 +0000 (GMT)
Received: from in.ibm.com (unknown [9.199.46.216])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 16 Dec 2019 03:29:13 +0000 (GMT)
Date:   Mon, 16 Dec 2019 08:59:11 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>, linuxram@us.ibm.com,
        kvm-ppc@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH V3 2/2] KVM: PPC: Implement H_SVM_INIT_ABORT hcall
Reply-To: bharata@linux.ibm.com
References: <20191215021104.GA27378@us.ibm.com>
 <20191215021208.GB27378@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191215021208.GB27378@us.ibm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-TM-AS-GCONF: 00
x-cbid: 19121603-0012-0000-0000-000003753716
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121603-0013-0000-0000-000021B11B34
Message-Id: <20191216032911.GA25495@in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-15_07:2019-12-13,2019-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=513 impostorscore=0
 clxscore=1015 mlxscore=0 phishscore=0 spamscore=0 malwarescore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912160029
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, Dec 14, 2019 at 06:12:08PM -0800, Sukadev Bhattiprolu wrote:
> +unsigned long kvmppc_h_svm_init_abort(struct kvm *kvm)
> +{
> +	int i;
> +
> +	if (!(kvm->arch.secure_guest & KVMPPC_SECURE_INIT_START))
> +		return H_UNSUPPORTED;
> +
> +	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> +		struct kvm_memory_slot *memslot;
> +		struct kvm_memslots *slots = __kvm_memslots(kvm, i);
> +
> +		if (!slots)
> +			continue;
> +
> +		kvm_for_each_memslot(memslot, slots)
> +			kvmppc_uvmem_drop_pages(memslot, kvm, false);
> +	}

You need to hold srcu_read_lock(&kvm->srcu) here.

Regards,
Bharata.

