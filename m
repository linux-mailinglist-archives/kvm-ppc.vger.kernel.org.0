Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8218B67B91
	for <lists+kvm-ppc@lfdr.de>; Sat, 13 Jul 2019 19:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbfGMR4R (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 13 Jul 2019 13:56:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37962 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727766AbfGMR4R (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 13 Jul 2019 13:56:17 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6DHpgPt195813;
        Sat, 13 Jul 2019 13:56:10 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tqbfwchx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 13 Jul 2019 13:56:10 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x6DHt3Ri004470;
        Sat, 13 Jul 2019 17:56:09 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03dal.us.ibm.com with ESMTP id 2tq6x6ktd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 13 Jul 2019 17:56:09 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6DHu8ws44302672
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Jul 2019 17:56:08 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82C63112061;
        Sat, 13 Jul 2019 17:56:08 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5DD8D112062;
        Sat, 13 Jul 2019 17:56:05 +0000 (GMT)
Received: from [9.85.164.240] (unknown [9.85.164.240])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Sat, 13 Jul 2019 17:56:05 +0000 (GMT)
Subject: Re: [PATCH v4 6/8] KVM: PPC: Ultravisor: Restrict LDBAR access
To:     Ram Pai <linuxram@us.ibm.com>, Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     maddy <maddy@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
        kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Anderson <andmike@linux.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>
References: <20190628200825.31049-1-cclaudio@linux.ibm.com>
 <20190628200825.31049-7-cclaudio@linux.ibm.com>
 <f153b6bf-4661-9dc0-c28f-076fc8fe598e@ozlabs.ru>
 <1e7f702a-c0cd-393d-934e-9e1a1234fe28@linux.vnet.ibm.com>
 <abe23edf-e593-ca98-8047-39ecb6cf16b5@ozlabs.ru>
 <20190701064642.GA5009@ram.ibm.com>
From:   Claudio Carvalho <cclaudio@linux.ibm.com>
Message-ID: <8a879fde-6636-9b55-c265-a2718f5279ec@linux.ibm.com>
Date:   Sat, 13 Jul 2019 14:56:04 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.0
MIME-Version: 1.0
In-Reply-To: <20190701064642.GA5009@ram.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-13_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=18 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907130218
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


On 7/1/19 3:46 AM, Ram Pai wrote:
> On Mon, Jul 01, 2019 at 04:30:55PM +1000, Alexey Kardashevskiy wrote:
>>
>> On 01/07/2019 16:17, maddy wrote:
>>> On 01/07/19 11:24 AM, Alexey Kardashevskiy wrote:
>>>> On 29/06/2019 06:08, Claudio Carvalho wrote:
>>>>> When the ultravisor firmware is available, it takes control over the
>>>>> LDBAR register. In this case, thread-imc updates and save/restore
>>>>> operations on the LDBAR register are handled by ultravisor.
>>>> What does LDBAR do? "Power ISA™ Version 3.0 B" or "User’s Manual POWER9
>>>> Processor" do not tell.
>>> LDBAR is a per-thread SPR used by thread-imc pmu to dump the counter
>>> data into memory.
>>> LDBAR contains memory address along with few other configuration bits
>>> (it is populated
>>> by the thread-imc pmu driver). It is populated and enabled only when any
>>> of the thread
>>> imc pmu events are monitored.
>>
>> I was actually looking for a spec for this register, what is the
>> document name?
>   Its not a architected register. Its documented in the Power9
>   workbook.

I also found some information about the LDBAR in
arch/powerpc/perf/imc-pmu.c

Claudio


>
> RP
>
