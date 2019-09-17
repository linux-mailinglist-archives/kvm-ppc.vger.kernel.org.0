Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6428EB5896
	for <lists+kvm-ppc@lfdr.de>; Wed, 18 Sep 2019 01:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfIQXfT (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 17 Sep 2019 19:35:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54782 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726234AbfIQXfS (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 17 Sep 2019 19:35:18 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8HNWqf3021895;
        Tue, 17 Sep 2019 19:35:06 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v37uctg6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Sep 2019 19:35:06 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x8HNYUXM036120;
        Tue, 17 Sep 2019 19:35:06 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v37uctg65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Sep 2019 19:35:05 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x8HNYVHn011993;
        Tue, 17 Sep 2019 23:35:04 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03wdc.us.ibm.com with ESMTP id 2v37jvgmq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Sep 2019 23:35:04 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8HNZ3Ys53150152
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Sep 2019 23:35:03 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B49D16E05B;
        Tue, 17 Sep 2019 23:35:03 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F6B06E053;
        Tue, 17 Sep 2019 23:35:03 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.70.94.45])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 17 Sep 2019 23:35:03 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 26FE12E10EA; Tue, 17 Sep 2019 16:35:02 -0700 (PDT)
Date:   Tue, 17 Sep 2019 16:35:02 -0700
From:   Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, cclaudio@linux.ibm.com, hch@lst.de,
        Paul Mackerras <paulus@ozlabs.org>
Subject: Re: [PATCH v8 4/8] kvmppc: H_SVM_INIT_START and H_SVM_INIT_DONE
 hcalls
Message-ID: <20190917233502.GD27932@us.ibm.com>
References: <20190910082946.7849-1-bharata@linux.ibm.com>
 <20190910082946.7849-5-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190910082946.7849-5-bharata@linux.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.10.1 (2018-07-13)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-17_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=929 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909170219
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


> +unsigned long kvmppc_h_svm_init_done(struct kvm *kvm)
> +{
> +	if (!(kvm->arch.secure_guest & KVMPPC_SECURE_INIT_START))

Minor: Should we also check if KVMPPC_SECURE_INIT_DONE is set here (since
both can be set)?
