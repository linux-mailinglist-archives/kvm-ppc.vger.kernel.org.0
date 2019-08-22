Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61AAC988EF
	for <lists+kvm-ppc@lfdr.de>; Thu, 22 Aug 2019 03:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbfHVB0v (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 21 Aug 2019 21:26:51 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30394 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727316AbfHVB0v (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 21 Aug 2019 21:26:51 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7M16xDT145290;
        Wed, 21 Aug 2019 21:26:45 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uhfx5tgab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Aug 2019 21:26:45 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7M1CjTG007128;
        Thu, 22 Aug 2019 01:26:44 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 2ue976jumj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Aug 2019 01:26:44 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7M1QhcV48562526
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 01:26:43 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B53ABAE066;
        Thu, 22 Aug 2019 01:26:43 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A92CAE05F;
        Thu, 22 Aug 2019 01:26:40 +0000 (GMT)
Received: from [9.80.203.17] (unknown [9.80.203.17])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 22 Aug 2019 01:26:40 +0000 (GMT)
Subject: Re: [PATCH v5 2/7] powerpc/kernel: Add ucall_norets() ultravisor call
 handler
To:     Segher Boessenkool <segher@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     linuxppc-dev@ozlabs.org,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>, kvm-ppc@vger.kernel.org,
        Bharata B Rao <bharata@linux.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Guerney Hunt <gdhh@linux.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>
References: <20190808040555.2371-1-cclaudio@linux.ibm.com>
 <20190808040555.2371-3-cclaudio@linux.ibm.com>
 <87wofgqb2g.fsf@concordia.ellerman.id.au>
 <20190814183432.GG31406@gate.crashing.org>
From:   Claudio Carvalho <cclaudio@linux.ibm.com>
Message-ID: <dbfbea49-c6b4-6bac-955d-8da03642db47@linux.ibm.com>
Date:   Wed, 21 Aug 2019 22:26:39 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.0
MIME-Version: 1.0
In-Reply-To: <20190814183432.GG31406@gate.crashing.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-22_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908220011
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


On 8/14/19 3:34 PM, Segher Boessenkool wrote:
> On Wed, Aug 14, 2019 at 08:46:15PM +1000, Michael Ellerman wrote:
>> Claudio Carvalho <cclaudio@linux.ibm.com> writes:
>>> +_GLOBAL(ucall_norets)
>>> +EXPORT_SYMBOL_GPL(ucall_norets)
>>> +	mfcr	r0
>>> +	stw	r0,8(r1)
>>> +
>>> +	sc	2		/* Invoke the ultravisor */
>>> +
>>> +	lwz	r0,8(r1)
>>> +	mtcrf	0xff,r0
>>> +	blr			/* Return r3 = status */
>> Paulus points that we shouldn't need to save CR here. Our caller will
>> have already saved it if it needed to, and we don't use CR in this
>> function so we don't need to save it.
>>
>> That's assuming the Ultravisor follows the hcall ABI in which CR2-4 are
>> non-volatile (PAPR § 14.5.3).
> And assuming the ultravisor already clears (or sets, or whatever) all CR
> fields it does not want to leak the contents of (which it also should,
> of course).

Thanks Segher. We are working on that in the ultravisor source code.

Claudio.


>
>> I know plpar_hcall_norets() does save CR, but it shouldn't need to, that
>> seems to be historical. aka. no one knows why it does it but it always
>> has.
>
> Segher
>
