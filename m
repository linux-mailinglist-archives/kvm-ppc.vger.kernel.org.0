Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3AF8121ED8
	for <lists+kvm-ppc@lfdr.de>; Tue, 17 Dec 2019 00:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfLPXUV (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 16 Dec 2019 18:20:21 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48042 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726705AbfLPXUV (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 16 Dec 2019 18:20:21 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBGNHY7k023576;
        Mon, 16 Dec 2019 18:20:13 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wwe4khucr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Dec 2019 18:20:12 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xBGNC5eO010813;
        Mon, 16 Dec 2019 23:20:12 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02dal.us.ibm.com with ESMTP id 2wvqc6d2aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Dec 2019 23:20:12 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBGNKAN658196398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Dec 2019 23:20:10 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA442BE056;
        Mon, 16 Dec 2019 23:20:10 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF401BE04F;
        Mon, 16 Dec 2019 23:19:57 +0000 (GMT)
Received: from morokweng.localdomain (unknown [9.85.177.201])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Mon, 16 Dec 2019 23:19:56 +0000 (GMT)
References: <20191216041924.42318-1-aik@ozlabs.ru> <20191216041924.42318-4-aik@ozlabs.ru>
User-agent: mu4e 1.2.0; emacs 26.2
From:   Thiago Jung Bauermann <bauerman@linux.ibm.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Michael Anderson <andmike@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH kernel v2 3/4] powerpc/pseries/iommu: Separate FW_FEATURE_MULTITCE to put/stuff features
In-reply-to: <20191216041924.42318-4-aik@ozlabs.ru>
Date:   Mon, 16 Dec 2019 20:19:46 -0300
Message-ID: <877e2vuact.fsf@morokweng.localdomain>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-16_07:2019-12-16,2019-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 clxscore=1015 bulkscore=0 adultscore=0 mlxscore=0
 spamscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 suspectscore=18 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912160195
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


Alexey Kardashevskiy <aik@ozlabs.ru> writes:

> H_PUT_TCE_INDIRECT allows packing up to 512 TCE updates into a single
> hypercall; H_STUFF_TCE can clear lots in a single hypercall too.
>
> However, unlike H_STUFF_TCE (which writes the same TCE to all entries),
> H_PUT_TCE_INDIRECT uses a 4K page with new TCEs. In a secure VM
> environment this means sharing a secure VM page with a hypervisor which
> we would rather avoid.
>
> This splits the FW_FEATURE_MULTITCE feature into FW_FEATURE_PUT_TCE_IND
> and FW_FEATURE_STUFF_TCE. "hcall-multi-tce" in
> the "/rtas/ibm,hypertas-functions" device tree property sets both;
> the "multitce=off" kernel command line parameter disables both.
>
> This should not cause behavioural change.
>
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Reviewed-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Tested-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>

-- 
Thiago Jung Bauermann
IBM Linux Technology Center
