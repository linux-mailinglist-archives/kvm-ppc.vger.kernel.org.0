Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9574C49B74A
	for <lists+kvm-ppc@lfdr.de>; Tue, 25 Jan 2022 16:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581531AbiAYPKs (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 25 Jan 2022 10:10:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31632 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1581559AbiAYPIu (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 25 Jan 2022 10:08:50 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20PF6vVD017985;
        Tue, 25 Jan 2022 15:08:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=7akWp2BkzOJRR7IyzM+2uFXpCM3WlnRs06iekYtyu88=;
 b=EU2e4venqt8HJk9A4UmGW8S9R7pCCmwxXbHM/NNj6QCqMhPkVAX0sdg8GuTDOplc1Xib
 V2qesQnmcYO2kYNDOXcl+9//OF0ooJSDf5kjLKW+f1bryoFKurcqJ9+Qb3G/dLjspYBo
 GtbLkyqCMmwT/aB0iby5M5JBFybhdNCalsjj9MaB31HKmdHVBzhtszt2AhoH25Q0Em/j
 e32L7w8LYLSWaTx7iJyXuCL7adpLoTqAG84tjZExSHdnPy0wnXmSnS+YgD5VzOLIc8S5
 ZyKfYaRgOWrmfEUHqzdCIKUuPU8qYq1nopIJQe/YuglAV41u2oHTL+9HQ9cEsmiDsINL JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dtjcwt5xf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 15:08:41 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20PF7Ggf021137;
        Tue, 25 Jan 2022 15:08:40 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dtjcwt5ws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 15:08:40 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20PF7P5o014198;
        Tue, 25 Jan 2022 15:08:39 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04wdc.us.ibm.com with ESMTP id 3dr9jaf5nv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 15:08:39 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20PF8cTv35062202
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 15:08:38 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78B0FAE064;
        Tue, 25 Jan 2022 15:08:38 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D5CFAE060;
        Tue, 25 Jan 2022 15:08:37 +0000 (GMT)
Received: from localhost (unknown [9.163.21.20])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTPS;
        Tue, 25 Jan 2022 15:08:36 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     aik@ozlabs.ru, linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
Subject: Re: [PATCH v2 4/4] KVM: PPC: Decrement module refcount if init_vm
 fails
In-Reply-To: <1643082153.tb99kluqtm.astroid@bobo.none>
References: <20220124220803.1011673-1-farosas@linux.ibm.com>
 <20220124220803.1011673-5-farosas@linux.ibm.com>
 <1643082153.tb99kluqtm.astroid@bobo.none>
Date:   Tue, 25 Jan 2022 12:08:33 -0300
Message-ID: <87mtjjx37y.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fVCRzM755aA2tnIKAm239vRx0dNPkG0a
X-Proofpoint-ORIG-GUID: -CK4ZymUITdiLjeIU16-NEPRZ7EvKfVg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_03,2022-01-25_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=888
 phishscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 clxscore=1015 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250098
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

> Excerpts from Fabiano Rosas's message of January 25, 2022 8:08 am:
>> We increment the reference count for KVM-HV/PR before the call to
>> kvmppc_core_init_vm. If that function fails we need to decrement the
>> refcount.
>> 
>> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
>> ---
>> Caught this while testing Nick's LPID patches by looking at
>> /sys/module/kvm_hv/refcnt
>
> Nice catch. Is this the only change in the series?

Yes.

> You can just use kvm_ops->owner like try_module_get() does I think? Also
> try_module_get works on a NULL module same as module_put by the looks,
> so you could adjust that in this patch to remove the NULL check so it
> is consistent with the put.

Sure, I'll send a v3.

