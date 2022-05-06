Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6CA951DA42
	for <lists+kvm-ppc@lfdr.de>; Fri,  6 May 2022 16:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352292AbiEFOSb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 6 May 2022 10:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442127AbiEFOSU (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 6 May 2022 10:18:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6EC689BE
        for <kvm-ppc@vger.kernel.org>; Fri,  6 May 2022 07:14:37 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 246DSTwK020380;
        Fri, 6 May 2022 14:14:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=gvAU8Nd4zQpfOK1+YDoyYyKjnCl1EJP9NFh/mEJF0Tg=;
 b=ARVVYGxcxR3GBVECHO3rWbKx/vd5i5Re/I2cdVO5oLf+fqFbPzP23nquMw135Q6ld0Gi
 pUHK9wRclw36yM3pEPfEBM/GUACwIKSPSJ8qaoB8EMXyTl5FsVxIPfXO44pCvEtYOgB9
 D9sHPBCBcXY73D5VMrYLhu0EvVfANjxprQ7Bu+nwIDcuYsM9tR/5HCCD0VUhZN1gvhsX
 vjwFs90c0/bd8rdHhL6H1xUb/IFfa5Qdko7+UJkZdhuobsZMMo4UbhWOkhyiAlVek+Sr
 aR1YPCoCn6bhDSY8vAbB/zlTpvvS43XJDjeEPe8W6tEunijnLm1KFlxmoSxnGD6YN4y4 kQ== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fw4k2s4h6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 14:14:32 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 246EEBpM027560;
        Fri, 6 May 2022 14:14:31 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02dal.us.ibm.com with ESMTP id 3frvrajwjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 14:14:31 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 246EEVx013500906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 May 2022 14:14:31 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0886EAE062;
        Fri,  6 May 2022 14:14:31 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 652A2AE05C;
        Fri,  6 May 2022 14:14:30 +0000 (GMT)
Received: from localhost (unknown [9.160.82.106])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTPS;
        Fri,  6 May 2022 14:14:29 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH kernel] KVM: PPC: Book3s: PR: Enable default TCE hypercalls
In-Reply-To: <20220506073737.3823347-1-aik@ozlabs.ru>
References: <20220506073737.3823347-1-aik@ozlabs.ru>
Date:   Fri, 06 May 2022 11:14:21 -0300
Message-ID: <878rreagua.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OwRcTF2SwCpTcgIQBvAPzUmY-CEFafb1
X-Proofpoint-GUID: OwRcTF2SwCpTcgIQBvAPzUmY-CEFafb1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_04,2022-05-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=599 bulkscore=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205060078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Alexey Kardashevskiy <aik@ozlabs.ru> writes:

> When KVM_CAP_PPC_ENABLE_HCALL was introduced, H_GET_TCE and H_PUT_TCE
> were already implemented and enabled by default; however H_GET_TCE
> was missed out on PR KVM (probably because the handler was in
> the real mode code at the time).
>
> This enables H_GET_TCE by default. While at this, this wraps
> the checks in ifdef CONFIG_SPAPR_TCE_IOMMU just like HV KVM.
>
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
