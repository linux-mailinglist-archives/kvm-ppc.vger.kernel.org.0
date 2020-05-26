Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7AF1E296D
	for <lists+kvm-ppc@lfdr.de>; Tue, 26 May 2020 19:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388499AbgEZRvd (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 26 May 2020 13:51:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59512 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388767AbgEZRvd (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 26 May 2020 13:51:33 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04QHWAvS079622;
        Tue, 26 May 2020 13:51:21 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 317003e6h1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 May 2020 13:51:20 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04QHkM6F026874;
        Tue, 26 May 2020 17:51:18 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 316uf8ajen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 May 2020 17:51:18 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04QHpGS4852274
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 May 2020 17:51:16 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 599DC11C058;
        Tue, 26 May 2020 17:51:16 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6E1911C05C;
        Tue, 26 May 2020 17:51:15 +0000 (GMT)
Received: from pomme.local (unknown [9.145.18.233])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 26 May 2020 17:51:15 +0000 (GMT)
Subject: Re: [PATCH] KVM: PPC: Book3S HV: read ibm,secure-memory nodes
From:   Laurent Dufour <ldufour@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulus@samba.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>, linux-kernel@vger.kernel.org
References: <20200416162715.45846-1-ldufour@linux.ibm.com>
Message-ID: <09a71476-1e15-e49b-3536-dabed9d881c0@linux.ibm.com>
Date:   Tue, 26 May 2020 19:51:15 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200416162715.45846-1-ldufour@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-26_02:2020-05-26,2020-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 cotscore=-2147483648 bulkscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 adultscore=0 clxscore=1011 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005260131
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Paul, could you please take that patch?

Le 16/04/2020 à 18:27, Laurent Dufour a écrit :
> The newly introduced ibm,secure-memory nodes supersede the
> ibm,uv-firmware's property secure-memory-ranges.
> 
> Firmware will no more expose the secure-memory-ranges property so first
> read the new one and if not found rollback to the older one.
> 
> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
> ---
>   arch/powerpc/kvm/book3s_hv_uvmem.c | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
> index 53b88cae3e73..ad950f8996e0 100644
> --- a/arch/powerpc/kvm/book3s_hv_uvmem.c
> +++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
> @@ -735,6 +735,20 @@ static u64 kvmppc_get_secmem_size(void)
>   	const __be32 *prop;
>   	u64 size = 0;
> 
> +	/*
> +	 * First try the new ibm,secure-memory nodes which supersede the
> +	 * secure-memory-ranges property.
> +	 * If we found somes, no need to read the deprecated one.
> +	 */
> +	for_each_compatible_node(np, NULL, "ibm,secure-memory") {
> +		prop = of_get_property(np, "reg", &len);
> +		if (!prop)
> +			continue;
> +		size += of_read_number(prop + 2, 2);
> +	}
> +	if (size)
> +		return size;
> +
>   	np = of_find_compatible_node(NULL, NULL, "ibm,uv-firmware");
>   	if (!np)
>   		goto out;
> 

