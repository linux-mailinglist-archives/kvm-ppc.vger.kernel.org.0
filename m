Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC230B5DDA
	for <lists+kvm-ppc@lfdr.de>; Wed, 18 Sep 2019 09:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfIRHRL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 18 Sep 2019 03:17:11 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19968 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726077AbfIRHRK (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 18 Sep 2019 03:17:10 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8I7D0Sw083898
        for <kvm-ppc@vger.kernel.org>; Wed, 18 Sep 2019 03:17:10 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v3fva0d6s-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Wed, 18 Sep 2019 03:17:09 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Wed, 18 Sep 2019 08:17:07 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Sep 2019 08:17:05 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8I7H3WV41025598
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 07:17:03 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DDCA11C05B;
        Wed, 18 Sep 2019 07:17:03 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88EBA11C054;
        Wed, 18 Sep 2019 07:17:01 +0000 (GMT)
Received: from in.ibm.com (unknown [9.199.59.145])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 18 Sep 2019 07:17:01 +0000 (GMT)
Date:   Wed, 18 Sep 2019 12:46:59 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, cclaudio@linux.ibm.com, hch@lst.de,
        Paul Mackerras <paulus@ozlabs.org>
Subject: Re: [PATCH v8 4/8] kvmppc: H_SVM_INIT_START and H_SVM_INIT_DONE
 hcalls
Reply-To: bharata@linux.ibm.com
References: <20190910082946.7849-1-bharata@linux.ibm.com>
 <20190910082946.7849-5-bharata@linux.ibm.com>
 <20190917233502.GD27932@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917233502.GD27932@us.ibm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-TM-AS-GCONF: 00
x-cbid: 19091807-0020-0000-0000-0000036E72ED
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19091807-0021-0000-0000-000021C41A51
Message-Id: <20190918071659.GB11675@in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-18_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=862 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909180076
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Sep 17, 2019 at 04:35:02PM -0700, Sukadev Bhattiprolu wrote:
> 
> > +unsigned long kvmppc_h_svm_init_done(struct kvm *kvm)
> > +{
> > +	if (!(kvm->arch.secure_guest & KVMPPC_SECURE_INIT_START))
> 
> Minor: Should we also check if KVMPPC_SECURE_INIT_DONE is set here (since
> both can be set)?

You imply that we can check if more H_SVM_INIT_DONE calls are issued
after first such call? Currently we just set the KVMPPC_SECURE_INIT_DONE
bit again.

Regards,
Bharata.

