Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE45D12FE00
	for <lists+kvm-ppc@lfdr.de>; Fri,  3 Jan 2020 21:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgACUhh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 3 Jan 2020 15:37:37 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61188 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727894AbgACUhg (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 3 Jan 2020 15:37:36 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 003KbWXf127808
        for <kvm-ppc@vger.kernel.org>; Fri, 3 Jan 2020 15:37:33 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2x9dr6j4es-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Fri, 03 Jan 2020 15:37:32 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <linuxram@us.ibm.com>;
        Fri, 3 Jan 2020 20:37:22 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 3 Jan 2020 20:37:18 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 003KbH9n39190900
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jan 2020 20:37:17 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66AAFA405F;
        Fri,  3 Jan 2020 20:37:17 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89413A405C;
        Fri,  3 Jan 2020 20:37:15 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.80.213.131])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  3 Jan 2020 20:37:15 +0000 (GMT)
Date:   Fri, 3 Jan 2020 12:37:12 -0800
From:   Ram Pai <linuxram@us.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>, bharata@linux.ibm.com,
        linuxppc-dev@ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v4 2/2] KVM: PPC: Implement H_SVM_INIT_ABORT hcall
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20191219215146.27278-1-sukadev@linux.ibm.com>
 <20191219215146.27278-2-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219215146.27278-2-sukadev@linux.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 20010320-0012-0000-0000-0000037A4AAB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20010320-0013-0000-0000-000021B65F2B
Message-Id: <20200103203712.GG5556@oc0525413822.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2020-01-03_06:2020-01-02,2020-01-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=828 adultscore=0 mlxscore=0 malwarescore=0 suspectscore=0
 spamscore=0 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001030187
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Dec 19, 2019 at 01:51:46PM -0800, Sukadev Bhattiprolu wrote:
> Implement the H_SVM_INIT_ABORT hcall which the Ultravisor can use to
> abort an SVM after it has issued the H_SVM_INIT_START and before the
> H_SVM_INIT_DONE hcalls. This hcall could be used when Ultravisor
> encounters security violations or other errors when starting an SVM.
> 
..snip..

> +unsigned long kvmppc_h_svm_init_abort(struct kvm *kvm)
> +{
> +	int srcu_idx;
> +	struct kvm_memory_slot *memslot;
> +
> +	/*
> +	 * Expect to be called only after INIT_START and before INIT_DONE.
> +	 * If INIT_DONE was completed, use normal VM termination sequence.
> +	 */
> +	if (!(kvm->arch.secure_guest & KVMPPC_SECURE_INIT_START) ||
> +			(kvm->arch.secure_guest & KVMPPC_SECURE_INIT_DONE))
> +		return H_UNSUPPORTED;

Ah.. this version has already incorporated my prior comment! I should
have reviewed your v4 version first.

One small comment.. H_STATE is a better return code than H_UNSUPPORTED.

RP

